import 'package:flutter/material.dart';
import 'package:flutter_projeto/services/userservices.dart'; // Importe a classe FirestoreService aqui

class AdicionarEntregaPage extends StatefulWidget {
  @override
  _AdicionarEntregaPageState createState() => _AdicionarEntregaPageState();
}

class _AdicionarEntregaPageState extends State<AdicionarEntregaPage> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Entrega'),
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
            ElevatedButton(
              onPressed: () async {
                await _firestoreService.addEntrega({
                  'cliente': 'Nome do Cliente',
                  'endereco': 'Endereço da Entrega',
                  // Adicione outros campos conforme necessário
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Entrega adicionada com sucesso!')),
                );
              },
              child: const Text('Adicionar Entrega'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }
}
