import 'package:flutter/material.dart';

class Registro_User extends StatefulWidget {
  const Registro_User({super.key});

  @override
  State<Registro_User> createState() => _Registro_UserState();
}

class _Registro_UserState extends State<Registro_User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Center(
        child: Text('Registro'),
      ),
    );
  }
}