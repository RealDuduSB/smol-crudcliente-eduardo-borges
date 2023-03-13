import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  String getDataNascimentoFormatada() {
    final formatoEntrada = DateFormat('ddMMyyyy');
    final dataOriginal = formatoEntrada.format(dataNascimento);
    final dataFormatada =
        '${dataOriginal.substring(4)}-${dataOriginal.substring(2, 4)}-${dataOriginal.substring(0, 2)}';
    return dataFormatada;
  }

  // Converter para JSON
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'cpf': cpf,
        'data_nascimento': DateFormat('yyyy-MM-dd').format(dataNascimento),
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

class ViewRegister extends StatefulWidget {
  const ViewRegister({super.key});

  @override
  _ViewRegisterState createState() => _ViewRegisterState();
}

class _ViewRegisterState extends State<ViewRegister> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  String? _sexoValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF20AB4E),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                "Cadastrar novo cliente",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o e-mail';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        TextFormField(
                          controller: _telefoneController,
                          decoration: InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o telefone';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        TextFormField(
                          controller: _cpfController,
                          decoration: InputDecoration(
                            labelText: 'CPF',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o CPF';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        TextFormField(
                          controller: _dataNascimentoController,
                          decoration: InputDecoration(
                            labelText: 'Data de Nascimento',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a data de nascimento';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        DecoratedBox(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration:
                                  const InputDecoration(labelText: 'Sexo'),
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
                          ),
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xFF18833D),
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            child: const Text(
                              "Cadastrar",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Cliente cliente; // Declaração da variável cliente
                              if (_formKey.currentState!.validate()) {
                                cliente = Cliente(
                                  nome: _nomeController.text,
                                  email: _emailController.text,
                                  telefone: _telefoneController.text,
                                  cpf: _cpfController.text,
                                  sexo: _sexoValue!,
                                  dataNascimento: DateTime.parse(
                                      _dataNascimentoController.text),
                                );
                                _cadastrarCliente(cliente);
                              }
                            },
                          ),
                        ),
                      ]),
                ),
              ))),
        ));
  }

  void _cadastrarCliente(Cliente cliente) async {
    final url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cliente cadastrado com sucesso'),
      ));
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao cadastrar cliente'),
      ));
    }
  }
}
