import 'package:cloud_firestore/cloud_firestore.dart';

class Entrega {
  String? id;
  String? endereco;
  String? cliente;

  //método construtor para inicializar as variáveis de instância
  Entrega({
    this.id,
    this.endereco,
    this.cliente,
  });

  //método utilizado para armazenar dados do documento
  //obtido no Firebase

  Entrega.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    endereco = doc['endereco'];
    cliente = doc['cliente'];
  }

  //Método utilizado para converter as informações
  //para formato JSON, que é o formato reconhecido pelo Firebase
  Map<String, dynamic> toMap() {
    return {
      'endereco': endereco,
      'cliente': cliente,
      'id': id,
    };
  }

  Entrega.fromMap(Map<String, dynamic> map) {
    endereco = map['endereco'];
    cliente = map['cliente'];
    id = map['id'];
  }
}
