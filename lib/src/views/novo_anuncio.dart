import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:olx/src/models/anuncio.dart';
import 'package:olx/src/util/configuracoes.dart';
import 'package:validadores/validadores.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/src/widgets/button_customizado.dart';
import 'package:olx/src/widgets/input_customizado.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerPreco = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  final _imagensAnuncios = <File>[];
  var _listaEstados = <DropdownMenuItem<String>>[];
  var _listaCategorias = <DropdownMenuItem<String>>[];

  BuildContext _dialogContext;

  String _estadoSelecionado; 
  String _categoriaSelecionada;

  Anuncio _anuncio;
  
  Future _recuperarImagem() async {
    //final ImagePicker _picker = ImagePicker();
    //File _imagemSelecionada = await _picker. tImage(source: ImageSource.gallery);
    File _imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imagemSelecionada != null) {
      setState(() {
        _imagensAnuncios.add(File(_imagemSelecionada.path));
      });
    }
  }

  _carregarListas() {
    _listaEstados = Configuracoes.getEstados();
    _listaCategorias = Configuracoes.getCategorias();
  }

  @override
  void initState() {
    super.initState();
    _carregarListas();
    _anuncio = Anuncio.gerarId();
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;

    await _uploadImagem();
    FirebaseFirestore db = FirebaseFirestore.instance;
    //& anúncio privado
    db.collection("meus_anuncios").doc(user.uid).collection("anuncios")
    .doc(_anuncio.id).set(_anuncio.toMap()).then((_) {
      //& anúncio público
      db.collection("anuncios")
      .doc(_anuncio.id)
      .set(_anuncio.toMap()).then((_) {
        Navigator.of(_dialogContext).pop();
        Navigator.of(context).pop();
      });
    });
    
  }

  Future<void> _uploadImagem() async {

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference pastaRaiz =  firebaseStorage.ref();

    for(var imagem in _imagensAnuncios) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(fileName + ".jpg");
      File file = File(imagem.path);  
      UploadTask uploadTask = arquivo.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.success) {
          String urlImagem = await snapshot.ref.getDownloadURL();
          _anuncio.fotos.add(urlImagem);
        }
      });
            
    }
    
  }

  _abrirDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Salvando Anúncio...")
            ])
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Anúncio")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _imagensAnuncios,
                  validator: (imagens) {
                    if (imagens.isEmpty) {
                      return "Necessário selecionar uma imagem";
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemCount: _imagensAnuncios.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index == _imagensAnuncios.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey[100]),
                                          Text("Adicionar", style: TextStyle(color: Colors.grey[100]))
                                        ]
                                      ),
                                    ),
                                    onTap: () => _recuperarImagem(),
                                  ),
                                );
                              }
                              return Visibility(
                                visible: _imagensAnuncios.length > 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(_imagensAnuncios[index]),
                                      radius: 50,
                                      child: Container(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.file(_imagensAnuncios[index]),
                                              FlatButton(
                                                child: Text("Excluir"),
                                                textColor: Colors.red,
                                                onPressed: () {
                                                  setState(() {
                                                    _imagensAnuncios.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });
                                                }, 
                                              )
                                            ]
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                replacement: Container(),
                              );                
                            }
                          )
                        ),
                        Visibility(
                          visible: field.hasError,
                          child: Container(
                            child: Text("[${field.errorText}]", style: TextStyle(color: Colors.red)),
                          )
                        )
                      ],
                    );
                  }
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _estadoSelecionado,
                          hint: Text("Estados"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaEstados,
                          onChanged: (value) {
                            setState(() {
                              _estadoSelecionado = value;
                            });
                          },
                          onSaved: (estado) {
                            _anuncio.estado = estado;
                          },
                          validator: (value) {
                            return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                          },
                        ),
                      )),
                    Expanded(child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _categoriaSelecionada,
                          hint: Text("Categorias"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaCategorias,
                          onChanged: (value) {
                            setState(() {
                              _categoriaSelecionada = value;
                            });
                          },
                          onSaved: (categoria) {
                            _anuncio.categoria = categoria;
                          },
                          validator: (value) {
                            return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                          },
                        ),
                      )),
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: InputCustomizado(
                    controller: _controllerTitulo,
                    hint: "Título",
                    validator: (value) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                        .valido(value);
                    },
                    onSaved: (titulo) {
                      _anuncio.titulo = titulo;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _controllerPreco,
                    hint: "Preço",
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    validator: (value) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                        .valido(value);
                    },
                    onSaved: (preco) {
                      _anuncio.preco = preco;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _controllerTelefone,
                    hint: "Telefone",
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (value) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                        .valido(value);
                    },
                    onSaved: (telefone) {
                      _anuncio.telefone = telefone;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _controllerDescricao,
                    hint: "Descrição",
                    validator: (value) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                        .maxLength(200, msg: "Máximo de 200 caracteres")
                        .valido(value);
                    },
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao;
                    },
                  ),
                ),
                ButtonCustomizado(
                  label: "Cadastrar Anúncio",
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _dialogContext = context;
                      await _salvarAnuncio();
                    }
                  },
                )
              ]
            ),
          ),
        )
      ),
    );
  }
}