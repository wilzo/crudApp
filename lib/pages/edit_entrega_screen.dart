import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_projeto/services/userservices.dart';
import 'package:intl/intl.dart';
import 'package:flutter_projeto/main.dart';

class EditEntregaScreen extends StatefulWidget {
  final String entregaId;

  const EditEntregaScreen({Key? key, required this.entregaId})
      : super(key: key);

  @override
  EditEntregaScreenState createState() => EditEntregaScreenState();
}

class EditEntregaScreenState extends State<EditEntregaScreen> {
  late TextEditingController _clienteController;
  late TextEditingController _enderecoController;
  late DateTime _selectedDate;
  final FirestoreService _firestoreService = FirestoreService();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController();
    _enderecoController = TextEditingController();
    _selectedDate = DateTime.now();

    // Preencha os controladores de texto com os detalhes da entrega atual
    _populateFields();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  void _populateFields() async {
    // Aqui você deve buscar os detalhes da entrega do Firestore usando widget.entregaId
    // Exemplo:
    Map<String, dynamic> entregaData =
        await _firestoreService.getEntregaData(widget.entregaId);
    // Atualize os controladores de texto e a data selecionada com os dados recuperados
    // Exemplo:
    _clienteController.text = entregaData['cliente'];
    _enderecoController.text = entregaData['endereco'];
    _selectedDate = entregaData['dataEntrega'];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _updateEntrega() async {
    // Crie um novo mapa com os dados atualizados
    Map<String, dynamic> newData = {
      'cliente': _clienteController.text,
      'endereco': _enderecoController.text,
      'dataEntrega': _selectedDate,
    };

    // Chame o método updateEntrega do seu FirestoreService para atualizar os dados
    bool success =
        await _firestoreService.updateEntrega(widget.entregaId, newData);

    if (success) {
      // Sucesso ao atualizar os dados
      // Você pode exibir uma mensagem ou navegar para outra tela aqui
    } else {
      // Falha ao atualizar os dados
      // Você pode exibir uma mensagem de erro aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Entrega'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _clienteController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text('Data de Entrega: ${_dateFormat.format(_selectedDate)}'),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateEntrega,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditClienteScreen extends StatefulWidget {
  final String clienteId;

  const EditClienteScreen({Key? key, required this.clienteId})
      : super(key: key);

  @override
  _EditClienteScreenState createState() => _EditClienteScreenState();
}

class _EditClienteScreenState extends State<EditClienteScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _telefoneController = TextEditingController();

    // Preencha os controladores de texto com os detalhes do cliente atual
    _populateFields();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _populateFields() async {
    // Aqui você deve buscar os detalhes do cliente do Firestore usando widget.clienteId
    // Exemplo:
    Map<String, dynamic> clienteData =
        await _firestoreService.getClienteData(widget.clienteId);
    // Atualize os controladores de texto com os dados recuperados
    // Exemplo:
    _nomeController.text = clienteData['nome'];
    _telefoneController.text = clienteData['telefone'];
  }

  Future<void> _updateCliente() async {
    // Crie um novo mapa com os dados atualizados
    Map<String, dynamic> newData = {
      'nome': _nomeController.text,
      'telefone': _telefoneController.text,
    };

    // Chame o método updateCliente do seu FirestoreService para atualizar os dados
    bool success =
        await _firestoreService.updateCliente(widget.clienteId, newData);

    if (success) {
      // Sucesso ao atualizar os dados
      // Você pode exibir uma mensagem ou navegar para outra tela aqui
    } else {
      // Falha ao atualizar os dados
      // Você pode exibir uma mensagem de erro aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateCliente,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditEntregadorScreen extends StatefulWidget {
  final String entregadorId;

  const EditEntregadorScreen({Key? key, required this.entregadorId})
      : super(key: key);

  @override
  _EditEntregadorScreenState createState() => _EditEntregadorScreenState();
}

class _EditEntregadorScreenState extends State<EditEntregadorScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _telefoneController = TextEditingController();

    // Preencha os controladores de texto com os detalhes do entregador atual
    _populateFields();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _populateFields() async {
    // Aqui você deve buscar os detalhes do entregador do Firestore usando widget.entregadorId
    // Exemplo:
    Map<String, dynamic> entregadorData =
        await _firestoreService.getEntregadorData(widget.entregadorId);
    // Atualize os controladores de texto com os dados recuperados
    // Exemplo:
    _nomeController.text = entregadorData['nome'];
    _telefoneController.text = entregadorData['telefone'];
  }

  Future<void> _updateEntregador() async {
    // Crie um novo mapa com os dados atualizados
    Map<String, dynamic> newData = {
      'nome': _nomeController.text,
      'telefone': _telefoneController.text,
    };

    // Chame o método updateEntregador do seu FirestoreService para atualizar os dados
    bool success =
        await _firestoreService.updateEntregador(widget.entregadorId, newData);

    if (success) {
      // Sucesso ao atualizar os dados
      // Você pode exibir uma mensagem ou navegar para outra tela aqui
    } else {
      // Falha ao atualizar os dados
      // Você pode exibir uma mensagem de erro aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Entregador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateEntregador,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
