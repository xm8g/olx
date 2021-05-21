import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/util/configuracoes.dart';
import 'package:olx/src/widgets/item_anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> _itensMenu = ["Meus Anúncios", "Logout"];
  String _estadoSelecionado;
  String _categoriaSelecionada = "0";
  var idUsuario = '';
  var _listaEstados = <DropdownMenuItem<String>>[];
  var _listaCategorias = <DropdownMenuItem<String>>[];
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _escolhaMenuItem(String itemEscolhido) {
    switch(itemEscolhido) {
      case "Meus Anúncios":
        Navigator.pushNamed(context, "/anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case "Logout":
        _logout();
        break;
    }
  }

  _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  Future _jaEstaLogado() async {

    User usuarioLogado = await _auth.currentUser;
    if (usuarioLogado == null) {
      _itensMenu.clear();
      _itensMenu.add("Entrar / Cadastrar");
    } else {
      idUsuario = usuarioLogado.uid;
    }
  }

  Future<Stream<QuerySnapshot>> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("anuncios");
    
    if (_estadoSelecionado != null) {
      query = query.where("estado", isEqualTo: _estadoSelecionado);
    }
    if (_categoriaSelecionada != '0') {
      query = query.where("categoria", isEqualTo: _categoriaSelecionada);
    }
    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((event) {
      _controller.add(event);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db.collection("anuncios").snapshots();

    stream.listen((event) {
      _controller.add(event);
    });
  }

  @override
  void initState() {
    _jaEstaLogado();
    super.initState();
    _listaEstados = Configuracoes.getEstados();
    _listaCategorias = Configuracoes.getCategorias();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OLX"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return _itensMenu.map((item) => PopupMenuItem<String>(
                value: item,
                child: Text(item),
              )).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Center(
                        child: DropdownButton(
                          iconEnabledColor: Color(0xFF9C27B0),
                          value: _estadoSelecionado,
                          items: _listaEstados,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black
                          ),
                          onChanged: (uf) {
                            setState(() {
                              _estadoSelecionado = uf;
                              _filtrarAnuncios();
                            });
                          },
                        ),
                      ),
                    )
                ),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Center(
                        child: DropdownButton(
                          iconEnabledColor: Color(0xFF9C27B0),
                          value: _categoriaSelecionada,
                          items: _listaCategorias,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black
                          ),
                          onChanged: (categoria) {
                            setState(() {
                              _categoriaSelecionada = categoria;
                              _filtrarAnuncios();
                            });
                          },
                        ),
                      ),
                    )
                )

              ],
            ),
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.docs.isEmpty) {
                    return Center(
                      child: Text("Nenhum Anúncio"),
                    );
                  }
                  List<DocumentSnapshot> documents = querySnapshot.docs.toList();
                  return Expanded(
                    child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          Anuncio anuncio = Anuncio.fromDocumentSnapshot(documents[index]);
                          return ItemAnuncio(
                            anuncio: anuncio,
                            onTapItem: (){
                              Navigator.pushNamed(context, "/detalhes-anuncio", arguments: anuncio);
                            },
                          );
                        }),
                  );
                },
            )
          ],
        ),
      ),
    );
  }
}