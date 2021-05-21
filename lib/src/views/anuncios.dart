import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/widgets/item_anuncio.dart';

class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  var idUsuario = '';

  Future<void> getUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    idUsuario = user.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    await getUsuarioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var stream = db.collection("meus_anuncios").doc(idUsuario).collection("anuncios").snapshots();

    stream.listen((event) {
      _controller.add(event);
    });

  }

  _removerAnuncio(String id) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios").doc(idUsuario)
      .collection("anuncios").doc(id).delete().then((_) {
        //& removendo anúncio público
        db.collection("anuncios").doc(id)
        .delete();
      });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Anúncios")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Adicionar"),
        onPressed: () => Navigator.pushNamed(context, "/novo-anuncio"),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          QuerySnapshot querySnapshot = snapshot.data;
          List<DocumentSnapshot> documents = querySnapshot.docs.toList();
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Anuncio anuncio = Anuncio.fromDocumentSnapshot(documents[index]);
              return ItemAnuncio(
                anuncio: anuncio,
                onPressedRemover: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('Confirmar'),
                      content: Text('Deseja realmente excluir ?'),
                      actions: [
                        FlatButton(
                          child: Text('NÂO', style: TextStyle(color: Colors.grey)),
                          onPressed: () => Navigator.of(context).pop()
                        ),
                        FlatButton(
                            child: Text('SIM', style: TextStyle(color: Colors.grey)),
                            onPressed: () {
                              _removerAnuncio(anuncio.id);
                              Navigator.of(context).pop();
                            }
                        ),
                      ],
                    );
                  });
                },
              );
            });
        })
      
    );
  }
}