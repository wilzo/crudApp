import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_projeto/services/entrega.dart';
import 'package:flutter_projeto/services/userservices.dart';
import 'package:flutter_projeto/pages/edit_entrega_screen.dart';
import 'package:intl/intl.dart';

void main() async {
  var options = const FirebaseOptions(
    apiKey: "AIzaSyCttynGIZgKkaaNVqUY7d8fBXii3b5nehE",
    authDomain: "crudprojeto-d77f3.firebaseapp.com",
    projectId: "crudprojeto-d77f3",
    storageBucket: "crudprojeto-d77f3.appspot.com",
    messagingSenderId: "728185143362",
    appId: "1:728185143362:web:db16b29e5b25baa8e0eddb",
    measurementId: "G-PN4KX059EF",
  );

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: options);
  } else {
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'AIzaSyCttynGIZgKkaaNVqUY7d8fBXii3b5nehE',
              appId: '1:728185143362:web:db16b29e5b25baa8e0eddb',
              messagingSenderId: '728185143362',
              projectId: 'crudprojeto-d77f3',
            ),
          )
        : Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Projeto',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/entregas': (context) => EntregasPage(),
        '/clientes': (context) => ClientesPage(),
        '/entregadores': (context) => EntregadoresPage(),
        '/adicionar_entrega': (context) => AdicionarEntregaPage(),
        '/adicionar_cliente': (context) => AdicionarClientePage(),
        '/adicionar_entregador': (context) => AdicionarEntregadorPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Crud App',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/entregas');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('TABELA ENTREGA'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clientes');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('TABELA CLIENTE'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/entregadores');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('TABELA ENTREGADOR'),
            ),
          ],
        ),
      ),
    );
  }
}

class EntregasPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Entregas'),
      ),
      body: StreamBuilder(
        stream: firestoreService.getEntregas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var entregas = snapshot.data?.docs;
            return ListView.builder(
              itemCount: entregas?.length ?? 0,
              itemBuilder: (context, index) {
                final entrega =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>?;

                Map<String, dynamic> transactionFinMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                Entrega entregaItem = Entrega.fromMap(transactionFinMap);

                return ListTile(
                  title: Text(entrega != null && entrega.containsKey('cliente')
                      ? entrega['cliente']
                      : 'Cliente não especificado'),
                  subtitle: Text(
                      entrega != null && entrega.containsKey('endereco')
                          ? entrega['endereco']
                          : 'Endereço não especificado'),
                  trailing: entrega != null && entrega.containsKey('id')
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditEntregaScreen(entregaId: entrega['id']),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  onLongPress: () {
                    if (entrega != null && entregaItem.id != null) {
                      firestoreService.deleteEntrega(entregaItem.id as String);
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adicionar_entrega');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientesPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: StreamBuilder(
        stream:
            firestoreService.getClientes(), // Altere para o método getClientes
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var clientes = snapshot.data?.docs;
            return ListView.builder(
              itemCount: clientes?.length ?? 0,
              itemBuilder: (context, index) {
                final cliente =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>?;

                Map<String, dynamic> clienteMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                Cliente clienteItem = Cliente.fromMap(clienteMap);

                return ListTile(
                  title: Text(cliente != null && cliente.containsKey('nome')
                      ? cliente['nome']
                      : 'Nome não especificado'),
                  subtitle: Text(
                      cliente != null && cliente.containsKey('telefone')
                          ? cliente['telefone']
                          : 'Telefone não especificado'),
                  trailing: cliente != null && cliente.containsKey('id')
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditClienteScreen(clienteId: cliente['id']),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  onLongPress: () {
                    if (cliente != null && clienteItem.id != null) {
                      firestoreService.deleteCliente(clienteItem.id as String);
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adicionar_cliente');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EntregadoresPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Entregadores'),
      ),
      body: StreamBuilder(
        stream: firestoreService.getEntregadores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var entregadores = snapshot.data?.docs;
            return ListView.builder(
              itemCount: entregadores?.length ?? 0,
              itemBuilder: (context, index) {
                final entregador =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>?;

                Map<String, dynamic> entregadorMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                Entregador entregadorItem = Entregador.fromMap(entregadorMap);

                return ListTile(
                  title: Text(
                      entregador != null && entregador.containsKey('nome')
                          ? entregador['nome']
                          : 'Nome não especificado'),
                  subtitle: Text(
                      entregador != null && entregador.containsKey('telefone')
                          ? entregador['telefone']
                          : 'Telefone não especificado'),
                  trailing: entregador != null && entregador.containsKey('id')
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEntregadorScreen(
                                    entregadorId: entregador['id']),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  onLongPress: () {
                    if (entregador != null && entregadorItem.id != null) {
                      firestoreService
                          .deleteEntregador(entregadorItem.id as String);
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adicionar_entregador');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final FirestoreService _firestoreService = FirestoreService();

class AdicionarEntregaPage extends StatefulWidget {
  @override
  _AdicionarEntregaPageState createState() => _AdicionarEntregaPageState();
}

class _AdicionarEntregaPageState extends State<AdicionarEntregaPage> {
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
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _enderecoController.dispose();
    super.dispose();
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
              onPressed: () async {
                await _firestoreService.addEntrega({
                  'cliente': _clienteController.text.trim(),
                  'endereco': _enderecoController.text.trim(),
                  'dataEntrega': _selectedDate,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entrega adicionada com sucesso!'),
                  ),
                );
                _clienteController.clear();
                _enderecoController.clear();
              },
              child: const Text('Adicionar Entrega'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdicionarClientePage extends StatefulWidget {
  @override
  _AdicionarClientePageState createState() => _AdicionarClientePageState();
}

class _AdicionarClientePageState extends State<AdicionarClientePage> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Cliente'),
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
              onPressed: () async {
                await _firestoreService.addCliente({
                  'nome': _nomeController.text.trim(),
                  'telefone': _telefoneController.text.trim(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente adicionado com sucesso!'),
                  ),
                );
                _nomeController.clear();
                _telefoneController.clear();
              },
              child: const Text('Adicionar Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdicionarEntregadorPage extends StatefulWidget {
  @override
  _AdicionarEntregadorPageState createState() =>
      _AdicionarEntregadorPageState();
}

class _AdicionarEntregadorPageState extends State<AdicionarEntregadorPage> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Entregador'),
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
              onPressed: () async {
                await _firestoreService.addEntregador({
                  'nome': _nomeController.text.trim(),
                  'telefone': _telefoneController.text.trim(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entregador adicionado com sucesso!'),
                  ),
                );
                _nomeController.clear();
                _telefoneController.clear();
              },
              child: const Text('Adicionar Entregador'),
            ),
          ],
        ),
      ),
    );
  }
}
