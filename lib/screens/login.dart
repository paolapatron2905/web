import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Iniciar Sesión', colorNew: Colors.teal),
      drawer: Custom_Drawer(),
    );
  }
}
