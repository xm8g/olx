import 'package:flutter/material.dart';
import 'package:olx/src/models/anuncio.dart';

class ItemAnuncio extends StatelessWidget {

  final Anuncio anuncio;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemAnuncio({@required this.anuncio, this.onPressedRemover, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(anuncio.fotos[0], fit: BoxFit.cover)
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(anuncio.titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('R\$ ${anuncio.preco}'),
                    ]
                  ),
                )
              ),
              Visibility(
                visible: onPressedRemover != null,
                child: Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Colors.red,
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.delete, color: Colors.white),
                      onPressed: onPressedRemover,
                    ),
                  )
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}