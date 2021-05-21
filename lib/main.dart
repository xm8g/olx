import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/src/views/home.dart';
import 'package:olx/src/views/route_generator.dart';

final ThemeData tema = ThemeData(
  primaryColor: Color(0xFF9C27B0),
  accentColor: Color(0xFF7B1FA2),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      title: 'OLX',
      theme: tema,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      home: Home(),
      onGenerateRoute: RouteGenerator.generateRoute,
    ));
}
