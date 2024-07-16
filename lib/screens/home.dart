import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/models/usuario.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos pasados a la ruta
    final usuario = Get.arguments as Usuario;

    final String bg_img = 'assets/images/bg.jpg';

    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Home', colorNew: Colors.green),
      drawer: Custom_Drawer(usuario: usuario), // Pasar el objeto usuario
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bg_img),
              ),
            ),
          ),
          Padding(
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
        ],
      ),
    );
  }
}
