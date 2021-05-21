import 'dart:convert';
import 'package:flutter/foundation.dart';

class Usuario {
  String id;
  String nome;
  String email;
  String senha;
  String urlImagem;
  
  Usuario({
    @required this.id,
    @required this.nome,
    @required this.email,
    @required this.senha,
    this.urlImagem,
  });

  

  Usuario copyWith({
    String id,
    String nome,
    String email,
    String senha,
    String urlImagem,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      urlImagem: urlImagem ?? this.urlImagem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'urlImagem': urlImagem,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      urlImagem: map['urlImagem'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) => Usuario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, senha: $senha, urlImagem: $urlImagem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Usuario &&
      other.id == id &&
      other.nome == nome &&
      other.email == email &&
      other.senha == senha &&
      other.urlImagem == urlImagem;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      email.hashCode ^
      senha.hashCode ^
      urlImagem.hashCode;
  }
}
