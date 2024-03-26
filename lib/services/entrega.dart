import 'package:cloud_firestore/cloud_firestore.dart';

class Entrega {
  String? id;
  String? endereco;
  String? cliente;
  DateTime? dataEntrega; // Novo atributo para data
  String? horaEntrega; // Novo atributo para hora

  // Construtor para inicializar as variáveis de instância
  Entrega({
    this.id,
    this.endereco,
    this.cliente,
    this.dataEntrega,
    this.horaEntrega,
  });

  // Método utilizado para armazenar dados do documento obtido no Firebase
  Entrega.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    endereco = doc['endereco'];
    cliente = doc['cliente'];
    // Verifica se a data de entrega está presente antes de atribuir
    if (doc['dataEntrega'] != null) {
      dataEntrega = (doc['dataEntrega'] as Timestamp).toDate();
    }
    horaEntrega = doc['horaEntrega'];
  }

  // Método utilizado para converter as informações para formato JSON, reconhecido pelo Firebase
  Map<String, dynamic> toMap() {
    return {
      'endereco': endereco,
      'cliente': cliente,
      'dataEntrega':
          dataEntrega != null ? Timestamp.fromDate(dataEntrega!) : null,
      'horaEntrega': horaEntrega,
      'id': id,
    };
  }

  // Método para inicializar a partir de um Map
  Entrega.fromMap(Map<String, dynamic> map) {
    endereco = map['endereco'];
    cliente = map['cliente'];
    // Verifica se a data de entrega está presente antes de atribuir
    if (map['dataEntrega'] != null) {
      dataEntrega = (map['dataEntrega'] as Timestamp).toDate();
    }
    horaEntrega = map['horaEntrega'];
    id = map['id'];
  }
}

class Cliente {
  String? id;
  String? nome;
  String? telefone;

  // Construtor para inicializar as variáveis de instância
  Cliente({
    this.id,
    this.nome,
    this.telefone,
  });

  // Método utilizado para armazenar dados do documento obtido no Firebase
  Cliente.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    nome = doc['nome'];
    telefone = doc['telefone'];
  }

  // Método utilizado para converter as informações para formato JSON, reconhecido pelo Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }

  // Método para inicializar a partir de um Map
  Cliente.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
  }
}

class Entregador {
  String? id;
  String? nome;
  String? telefone;

  // Construtor para inicializar as variáveis de instância
  Entregador({
    this.id,
    this.nome,
    this.telefone,
  });

  // Método utilizado para armazenar dados do documento obtido no Firebase
  Entregador.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    nome = doc['nome'];
    telefone = doc['telefone'];
  }

  // Método utilizado para converter as informações para formato JSON, reconhecido pelo Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }

  // Método para inicializar a partir de um Map
  Entregador.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
  }
}
