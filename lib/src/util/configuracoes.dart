import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {

  static const _categorias = <Map<String, dynamic>>[
    { 'categoria': 'Categoria', 'id': '0' },
    { 'categoria': 'Imóveis', 'id': '1' },
    { 'categoria': 'Automóveis', 'id': '2' },
    { 'categoria': 'Móveis', 'id': '3' },
    { 'categoria': 'Eletrônicos', 'id': '4' },
    { 'categoria': 'Serviços', 'id': '5' }
  ];

  static List<DropdownMenuItem<String>> getCategorias() {
    return _categorias.map((value) {
      return DropdownMenuItem<String>(
          value: value['id'],
          child: Text(value['categoria'], style: TextStyle(
            color: value['id'] == '0' ? Color(0xFF9C27B0) : Colors.black
          ))
      );
    }).toList();
  }

  static List<DropdownMenuItem<String>> getEstados() {
    var listaEstados = <DropdownMenuItem<String>>[];
    listaEstados.add(DropdownMenuItem<String>(
        value: null,
        child: Text('Região', style: TextStyle(color: Color(0xFF9C27B0)))
    ));
    listaEstados.addAll(Estados.listaEstadosSigla.map((String uf) {
      return DropdownMenuItem<String>(
          value: uf,
          child: Text(uf)
      );
    }).toList());
    return listaEstados;
  }
}