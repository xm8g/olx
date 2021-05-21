import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/models/usuario.dart';
import 'package:olx/src/widgets/button_customizado.dart';
import 'package:olx/src/widgets/input_customizado.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _cadastrar = false;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String msgErro = '';

  String _buttonText = "Entrar";

  void _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty) {
          setState(() {
            msgErro = '';
          });
          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;
          if (_cadastrar) {
            _cadastrarUsuario(usuario);
          } else {
            _logar(usuario);
          }
        } else {
          setState(() {
            msgErro = "Preencha a senha.";
          });
        }
      } else {
        setState(() {
          msgErro = "E-mail não preenchido ou inválido";
        });
      }
  }

  void _logar(Usuario usuario) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.senha)).user;
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    } catch (error) {
      setState(() {
        msgErro =
        "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente.";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha))
        .user;
    if (user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuarios").doc(user.uid).set(usuario.toMap());
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    } else {
      setState(() {
        msgErro =
            "Erro ao cadastrar usuário, verifique os campos e tente novamente.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Image.asset("assets/images/logo.png",
                  width: 200, height: 150),
            ),
            InputCustomizado(
                controller: _controllerEmail,
                hint: "E-mail",
                autoFocus: true,
                type: TextInputType.emailAddress),
            InputCustomizado(
                controller: _controllerSenha, 
                hint: "Senha", 
                obscure: true),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Logar"),
              Switch(
                  value: _cadastrar,
                  onChanged: (bool value) {
                    setState(() {
                      _cadastrar = value;
                      _buttonText = value ? "Cadastrar" : "Entrar";
                    });
                  }),
              Text("Cadastrar")
            ]),
            ButtonCustomizado(
              label: _buttonText,
              onPressed: () => _validarCampos(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(msgErro, style: TextStyle(color: Colors.red, fontSize: 20))),
            )
          ],
        ))),
      ),
    );
  }
}
