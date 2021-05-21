import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {

  Anuncio anuncio;

  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {

  Anuncio _anuncio;



  List<Widget> _getListImagens() {
    List<String> _listaImagens = _anuncio.fotos;
    return _listaImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth
          )
        ),
      );
    }).toList();
  }

  _ligarTelefone(String telefone) async {
    if ( await canLaunch("tel:$telefone")) {
      await launch("tel:$telefone");
    } else {
      print("Não pode fazer a ligação");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anúncio")),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getListImagens(),
                  dotSize: 8,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("R\$ ${_anuncio.preco}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Theme.of(context).primaryColor
                    )),
                    Text("${_anuncio.titulo}", style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text("Descrição", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                    Text("${_anuncio.descricao}", style: TextStyle(
                      fontSize: 18,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text("Contato", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 66),
                      child: Text("${_anuncio.telefone}", style: TextStyle(
                        fontSize: 18,
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text("Ligar",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              onTap: () => _ligarTelefone(_anuncio.telefone),
            ),
          )
        ]
      ),
    );
  }
}
