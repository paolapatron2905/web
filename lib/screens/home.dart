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

// Variables para colores
    Color color_container = Color.fromARGB(255, 124, 213, 44);
    Color color_appbar = Color.fromARGB(255, 44, 111, 127);
    Color color_bgInputs = Colors.white;
    Color color_effects = Colors.black.withOpacity(0.5);
    Color color_fonts_1 = Colors.black;
    Color color_fonts_2 = Colors.white;
    Color color_button1 = Color.fromARGB(255, 70, 160, 30);
    Color color_button2 = Color.fromARGB(255, 4, 33, 49);

    // Variables para imagenes
    final String bg_img = '../assets/img/bg.jpg';
    final String logo_img = '../assets/img/logo.png';

    return Scaffold(
      // Barra de título
      appBar: Custom_Appbar(
        titulo: 'Home',
        colorNew: color_container,
        textColor: color_fonts_2,
      ),

      // Barra lateral
      drawer: Custom_Drawer(usuario: usuario), // Pasar el objeto usuario

      // Contenido principal
      body: Stack(
        children: [
          // Contenedor del fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bg_img),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Fondo Transparente
          Container(
            color: color_effects,
          ),

          // Contendido o texto
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido, ${usuario.username}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: color_fonts_2,
                  ),
                ),

                // Espaciado
                SizedBox(height: 10),

                // Texto de bienvenida
                Text(
                  'Tipo de Usuario: ${usuario.tipoUsuario}',
                  style: TextStyle(
                    fontSize: 18,
                    color: color_fonts_2,
                  ),
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
