import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/views/anuncios.dart';
import 'package:olx/src/views/detalhes_anuncio.dart';
import 'package:olx/src/views/login.dart';
import 'package:olx/src/views/novo_anuncio.dart';

import 'home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch(settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/":
        return MaterialPageRoute(builder: (context) => Home());
      case "/anuncios":
        return MaterialPageRoute(builder: (context) => Anuncios());
      case "/novo-anuncio":
        return MaterialPageRoute(builder: (context) => NovoAnuncio());
      case "/detalhes-anuncio":
        return MaterialPageRoute(builder: (context) => DetalhesAnuncio(args));
      default:
        return erroRota();
    }
  }

  static Route<dynamic> erroRota() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada")),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}