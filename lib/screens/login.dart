import 'package:flutter/material.dart';
import 'package:inventario/constants/appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(titulo: 'Iniciar Sesión', color: Colors.teal),
      drawer: CustomDrawer(),
    );
  }
}
