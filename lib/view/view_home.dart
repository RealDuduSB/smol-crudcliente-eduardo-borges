import 'package:flutter/material.dart';
import 'package:smol_crudcliente_eduardo_borges/view/view_edit.dart';
import 'package:smol_crudcliente_eduardo_borges/view/view_register.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widgets/widget_list_clients.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cliente {
  final int id;
  final String nome;
  final String email;
  final String telefone;

  Cliente({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}

class ViewHome extends StatefulWidget {
  const ViewHome({Key? key}) : super(key: key);

  @override
  State<ViewHome> createState() => _ViewHomeState();
}

class _ViewHomeState extends State<ViewHome> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  int? deletedTodoPos;

  String? errorText;
  late List<Cliente> _clientes;
  Cliente? _clienteSelecionado;

  @override
  void initState() {
    super.initState();
    _getClientes();
  }

  Future<void> _getClientes() async {
    final response = await http.get(Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/'));
    if (response.statusCode == 200) {
      setState(() {
        _clientes = (jsonDecode(response.body) as List)
            .map((data) => Cliente.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Erro ao obter dados do endpoint');
    }
  }

  void _editarCliente(Cliente cliente) {
    setState(() {
      _clienteSelecionado = cliente;
      nomeController.text = cliente.nome;
      emailController.text = cliente.email;
      telefoneController.text = cliente.telefone;
    });
  }

  Future<void> updateCliente(int id, Cliente cliente) async {
    final response = await http.put(
      Uri.parse(
          'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200) {
      // Atualiza a lista de clientes após a atualização do cliente
      _getClientes();
    } else {
      throw Exception('Erro ao atualizar o cliente');
    }
  }

  Future<void> deleteCliente(String id) async {
    final response = await http.delete(
      Uri.parse(
          'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/$id/'),
    );
    if (response.statusCode == 200) {
      // cliente excluído com sucesso
      // Atualize a lista de clientes
      _getClientes();
    } else {
      throw Exception('Erro ao excluir cliente');
    }
  }

  Future<void> _handleRefresh() async {
    await _getClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clientes == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    // Altura da imagem
                    width: double.infinity,
                    // Largura da imagem (no caso, ocupando toda a largura disponível)
                    child: Image.asset(
                        'assets/images/logo.png'),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewRegister()),
                        );
                      },
                      child: const Text("Cadastrar Cliente")),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: _clientes.length,
                        itemBuilder: (context, index) {
                          final cliente = _clientes[index];
                          return ListTile(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewEdit(clienteId: cliente.id),
                                ),
                              );
                            },
                            title: Text(cliente.nome),
                            subtitle: Text(cliente.email),
                            trailing: Text(cliente.telefone),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
