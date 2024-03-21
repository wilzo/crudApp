import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Operações CRUD para a tabela de entregas
  Future<void> addEntrega(Map<String, dynamic> entregaData) async {
    await _db.collection('entregas').add(entregaData);
  }

  Stream<QuerySnapshot> getEntregas() {
    return _db.collection('entregas').snapshots();
  }

  Future<void> updateEntrega(
      String entregaId, Map<String, dynamic> newData) async {
    await _db.collection('entregas').doc(entregaId).update(newData);
  }

  Future<void> deleteEntrega(String entregaId) async {
    await _db.collection('entregas').doc(entregaId).delete();
  }

  // Repita o mesmo padrão para as outras tabelas (clientes, produtos, entregadores, rotas)
}
