import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  
  String id;
  String estado;
  String categoria;
  String titulo;
  String preco;
  String descricao;
  String telefone;
  List<String> fotos;

  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.estado = documentSnapshot['estado'];
    this.categoria = documentSnapshot['categoria'];
    this.titulo = documentSnapshot['titulo'];
    this.preco = documentSnapshot['preco'];
    this.descricao = documentSnapshot['descricao'];
    this.telefone = documentSnapshot['telefone'];
    this.fotos = List<String>.from(documentSnapshot['fotos']);
  }

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus-anuncios");
    this.id = anuncios.doc().id;
    this.fotos = [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estado': estado,
      'categoria': categoria,
      'titulo': titulo,
      'preco': preco,
      'descricao': descricao,
      'telefone': telefone,
      'fotos': fotos
    };
  }

  factory Anuncio.fromMap(Map<String, dynamic> map) {
    var anuncio = Anuncio();
    
    anuncio.id = map['id'];
    anuncio.estado = map['estado'];
    anuncio.categoria = map['categoria'];
    anuncio.titulo = map['titulo'];
    anuncio.preco = map['preco'];
    anuncio.descricao = map['descricao'];
    anuncio.telefone = map['telefone'];
    anuncio.fotos = map['fotos'];

    return anuncio;
  }

  String toJson() => json.encode(toMap());

  factory Anuncio.fromJson(String source) => Anuncio.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Anuncio(id: $id, estado: $estado, categoria: $categoria, titulo: $titulo, preco: $preco, descricao: $descricao, telefone: $telefone)';
  }

}
