import 'package:flutter/material.dart';

class EditEntregaScreen extends StatefulWidget {
  final String entregaId;

  const EditEntregaScreen({Key? key, required this.entregaId})
      : super(key: key);

  @override
  EditEntregaScreenState createState() => EditEntregaScreenState();
}

class EditEntregaScreenState extends State<EditEntregaScreen> {
  // Implemente o estado aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Entrega'),
      ),
      body: Center(
        child: Text('Editar entrega com ID: ${widget.entregaId}'),
      ),
    );
  }
}
