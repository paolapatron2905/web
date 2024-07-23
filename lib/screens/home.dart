import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/models/usuario.dart';
import 'package:get/get.dart';
import 'package:inventario/models/sesion.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    validar_sesion();
  }

  validar_sesion() async {
    int? tipo = await Sesion().sesion();
    if (tipo == 3) {
      print('tipo de usuario 3');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos pasados a la ruta
    final usuario = Get.arguments as Usuario;

    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Home', colorNew: Colors.green),
      drawer: Custom_Drawer(), // Pasar el objeto usuario
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ${usuario.username}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Tipo de Usuario: ${usuario.tipoUsuario}',
              style: TextStyle(fontSize: 18),
            ),
            // Aquí puedes agregar más widgets o lógica según sea necesario
          ],
        ),
      ),
    );
  }
}
