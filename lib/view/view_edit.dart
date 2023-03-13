import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smol_crudcliente_eduardo_borges/view/view_home.dart';

class Cliente {
  String nome;
  String email;
  String telefone;
  String cpf;
  DateTime dataNascimento;
  String sexo;

  Cliente({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
  });

  // Validar os dados do cliente
  bool get isNomeValido => nome.isNotEmpty;

  bool get isEmailValido => email.isNotEmpty && email.contains('@');

  bool get isTelefoneValido => telefone.isNotEmpty;

  bool get isCpfValido => cpf.isNotEmpty && cpf.length == 11;

  bool get isDataNascimentoValida => dataNascimento.isBefore(DateTime.now());

  // Obter a data de nascimento formatada
  String getDataNascimentoFormatada() {
    final formatoEntrada = DateFormat('dd-MM-yyyy');
    final formatoSaida = DateFormat('yyyy-MM-dd');
    final dataFormatada = formatoEntrada.parse(dataNascimento.toString());
    return formatoSaida.format(dataFormatada);
  }

  // Converter para JSON
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'cpf': cpf,
        'data_nascimento': dataNascimento,
        'sexo': sexo,
      };

  // Converter de JSON
  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        nome: json['nome'],
        email: json['email'],
        telefone: json['telefone'],
        cpf: json['cpf'],
        dataNascimento: DateTime.parse(json['data_nascimento']),
        sexo: json['sexo'],
      );
}

class ViewEdit extends StatefulWidget {
  final int clienteId;

  const ViewEdit({Key? key, required this.clienteId}) : super(key: key);

  @override
  _ViewEditState createState() => _ViewEditState();
}

class _ViewEditState extends State<ViewEdit> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  int get clienteId => widget.clienteId;
  String? _sexoValue;
  late List<Cliente> _clientes;

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
  Future<void> _buscarCliente() async {
    final response = await http.get(Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/${widget.clienteId}/'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final cliente = Cliente.fromJson(json);

      _nomeController.text = cliente.nome;
      _emailController.text = cliente.email;
      _telefoneController.text = cliente.telefone;
      _cpfController.text = cliente.cpf;
      _dataNascimentoController.text = cliente.getDataNascimentoFormatada();
      _sexoValue = cliente.sexo;
    }
  }

  @override
  void initState() {
    super.initState();
    _buscarCliente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Alterar dados'),
          actions: [
            IconButton(onPressed: (){
              _showDeleteConfirmation(context, clienteId);
            }, icon: const Icon(Icons.delete)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          hintText: _nomeController.text.isNotEmpty
                              ? null
                              : 'Insira o nome',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'email',
                          hintText: _emailController.text.isNotEmpty
                              ? null
                              : 'Insira o email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefone',
                          hintText: _telefoneController.text.isNotEmpty
                              ? null
                              : 'Insira o telefone',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o telefone';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _cpfController,
                        decoration: InputDecoration(
                          labelText: 'CPF',
                          hintText: _cpfController.text.isNotEmpty
                              ? null
                              : 'Insira o CPF',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o CPF';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        // inputFormatters: [
                        //   MaskTextInputFormatter(
                        //       mask: '##/##/####',
                        //       filter: {"#": RegExp(r'[0-9]')}),
                        // ],
                        controller: _dataNascimentoController,
                        // decoration: InputDecoration(
                        //   labelText: 'Data de nascimento',
                        //   hintText: _dataNascimentoController.text.isNotEmpty
                        //       ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                        //           _dataNascimentoController.text))
                        //       : 'Insira a data de nascimento',
                        // ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a data de nascimento';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Sexo'),
                        value: _sexoValue,
                        onChanged: (value) {
                          setState(() {
                            _sexoValue = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Masculino',
                            child: Text('Masculino'),
                          ),
                          DropdownMenuItem(
                            value: 'Feminino',
                            child: Text('Feminino'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final cliente = Cliente(
                              nome: _nomeController.text,
                              email: _emailController.text,
                              telefone: _telefoneController.text,
                              cpf: _cpfController.text,
                              dataNascimento: DateTime.parse(_dataNascimentoController.text),
                              sexo: _sexoValue!,
                            );
                            _atualizarCliente();
                          }
                        },
                        child: const Text('Atualizar'),
                      ),
                    ]),
              )),
        ));
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

  Future<void> _atualizarCliente() async {
    final url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/${widget.clienteId}/');
    final headers = {
      'Content-Type': 'application/json',
    };
    final cliente = Cliente(
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      cpf: _cpfController.text,
      dataNascimento: DateTime.parse(_dataNascimentoController.text),
      sexo: _sexoValue!,
    );
    final body = jsonEncode(cliente.toJson());
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      throw Exception('Falha ao atualizar cliente');
    }
  }
  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Deseja realmente excluir este cliente?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                deleteCliente(id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewHome()),
                );
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
