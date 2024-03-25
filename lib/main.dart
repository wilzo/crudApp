import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_projeto/services/entrega.dart';
import 'package:flutter_projeto/services/userservices.dart';
import 'package:flutter_projeto/pages/edit_entrega_screen.dart';

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
        '/adicionar_entrega': (context) => AdicionarEntregaPage(),
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
        title: const Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/entregas');
              },
              child: const Text('Ver Entregas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/adicionar_entrega');
              },
              child: const Text('Adicionar Entrega'),
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

class AdicionarEntregaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _clienteController = TextEditingController();
    final TextEditingController _enderecoController = TextEditingController();
    final FirestoreService _firestoreService = FirestoreService();

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
                  'cliente': _clienteController.text.trim(),
                  'endereco': _enderecoController.text.trim(),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Entrega adicionada com sucesso!')),
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
