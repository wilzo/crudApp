import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projeto/services/entrega.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEntrega(Map<String, dynamic> entregaData) async {
    _db.collection('entregas').add(entregaData).then((value) {
      entregaData.addAll({'id': value.id});
      _db.collection('entregas').doc(value.id).set(entregaData);
    });
  }

  Stream<QuerySnapshot> getEntregas() {
    return _db.collection('entregas').snapshots();
  }

  Future<Map<String, dynamic>> getEntregaData(String entregaId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('entregas').doc(entregaId).get();
      if (doc.exists) {
        // Se o documento existir, retorne os dados da entrega
        return doc.data() as Map<String, dynamic>;
      } else {
        // Se o documento não existir, retorne um mapa vazio ou null
        return {}; // ou return null;
      }
    } catch (e) {
      // Se ocorrer algum erro, trate-o conforme necessário (ex: registro de erro, retorno de erro, etc.)
      print('Erro ao buscar dados da entrega: $e');
      return {}; // ou return null;
    }
  }

  Future<bool> updateEntrega(
      String entregaId, Map<String, dynamic> newData) async {
    try {
      await _db.collection('entregas').doc(entregaId).update(newData);
      return true; // Retorna true se a atualização foi bem-sucedida
    } catch (e) {
      // Se ocorrer um erro, trate-o conforme necessário e retorne false
      print('Erro ao atualizar a entrega: $e');
      return false; // Retorna false se ocorrer um erro
    }
  }

  Future<void> deleteEntrega(String entregaId) async {
    try {
      await _db.collection('entregas').doc(entregaId).delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      if (e.code != 'OK') {
        debugPrint('Problemas ao deletar a entrega');
      } else if (e.code == 'ABORTED') {
        debugPrint('Deleção abortada');
      }
      return Future.value(false);
    }
  }

  Future<void> addCliente(Map<String, dynamic> clienteData) async {
    _db.collection('clientes').add(clienteData).then((value) {
      clienteData.addAll({'id': value.id});
      _db.collection('clientes').doc(value.id).set(clienteData);
    });
  }

  Stream<QuerySnapshot> getClientes() {
    return _db.collection('clientes').snapshots();
  }

  Future<Map<String, dynamic>> getClienteData(String clienteId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('clientes').doc(clienteId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Erro ao buscar dados do cliente: $e');
      return {};
    }
  }

  Future<bool> updateCliente(
      String clienteId, Map<String, dynamic> newData) async {
    try {
      await _db.collection('clientes').doc(clienteId).update(newData);
      return true;
    } catch (e) {
      print('Erro ao atualizar o cliente: $e');
      return false;
    }
  }

  Future<void> deleteCliente(String clienteId) async {
    try {
      await _db.collection('clientes').doc(clienteId).delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      if (e.code != 'OK') {
        debugPrint('Problemas ao deletar o cliente');
      } else if (e.code == 'ABORTED') {
        debugPrint('Deleção abortada');
      }
      return Future.value(false);
    }
  }

  Future<void> addEntregador(Map<String, dynamic> entregadorData) async {
    _db.collection('entregadores').add(entregadorData).then((value) {
      entregadorData.addAll({'id': value.id});
      _db.collection('entregadores').doc(value.id).set(entregadorData);
    });
  }

  Stream<QuerySnapshot> getEntregadores() {
    return _db.collection('entregadores').snapshots();
  }

  Future<Map<String, dynamic>> getEntregadorData(String entregadorId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('entregadores').doc(entregadorId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Erro ao buscar dados do entregador: $e');
      return {};
    }
  }

  Future<bool> updateEntregador(
      String entregadorId, Map<String, dynamic> newData) async {
    try {
      await _db.collection('entregadores').doc(entregadorId).update(newData);
      return true;
    } catch (e) {
      print('Erro ao atualizar o entregador: $e');
      return false;
    }
  }

  Future<void> deleteEntregador(String entregadorId) async {
    try {
      await _db.collection('entregadores').doc(entregadorId).delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      if (e.code != 'OK') {
        debugPrint('Problemas ao deletar o entregador');
      } else if (e.code == 'ABORTED') {
        debugPrint('Deleção abortada');
      }
      return Future.value(false);
    }
  }
}
