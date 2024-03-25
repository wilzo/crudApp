import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projeto/services/entrega.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference firestoreRef;

  // Operações CRUD para a tabela de entregas
  Future<void> addEntrega(Map<String, dynamic> entregaData) async {
    _db.collection('entregas').add(entregaData).then((value) {
      entregaData.addAll({'id': value.id});
      _db.collection('entregas').doc(value.id).set(entregaData);
    });
  }

  Stream<QuerySnapshot> getEntregas() {
    return _db.collection('entregas').snapshots();
  }

  Future<void> updateEntrega(
      String entregaId, Map<String, dynamic> newData) async {
    try {
      await firestoreRef.doc(entregaId).update(newData);
      return Future.value(true);
    } on FirebaseException catch (e) {
      if (e.code != 'OK') {
        debugPrint('Problemas ao deletar a transação');
      } else if (e.code == 'ABORTED') {
        debugPrint('Deleção abortada');
      }
      return Future.value(false);
    }
  }

  Future<void> deleteEntrega(String entregaId) async {
    try {
      await _db.collection('entregas').doc(entregaId).delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      if (e.code != 'OK') {
        debugPrint('Problemas ao deletar a transação');
      } else if (e.code == 'ABORTED') {
        debugPrint('Deleção abortada');
      }
      return Future.value(false);
    }
  }

  // Repita o mesmo padrão para as outras tabelas (clientes, produtos, entregadores, rotas)
}
