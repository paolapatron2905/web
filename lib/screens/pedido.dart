import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/custom_appbar.dart';

class Pedido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Get.parameters['userId'];
    final productId = Get.parameters['productId'];

    // Variables de diseño (colores)
    Color color_container = Color.fromARGB(255, 124, 213, 44);
    // Color color_appbar = Color.fromARGB(255, 44, 111, 127);
    // Color color_bgInputs = Colors.white;
    Color color_effects = Colors.black.withOpacity(0.5);
    // Color color_fonts_1 = Colors.black;
    Color color_fonts_2 = Colors.white;
    Color color_button1 = Color.fromARGB(255, 70, 160, 30);
    // Color color_button2 = Color.fromARGB(255, 4, 33, 49);

    // Imágenes y rutas
    final String bg_img = '../assets/img/bg.jpg';
    final String bg_img2 = '../assets/img/bg_registrer.jpg';

    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Nuevo Pedido',
        colorNew: color_container,
      ),
      body: Stack(
        children: [
          // Fondo 1
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bg_img),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Fondo 2
          Container(
            color: color_effects,
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'User ID: $userId',
                  style: TextStyle(fontSize: 18, color: color_fonts_2),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Product ID: $productId',
                  style: TextStyle(fontSize: 18, color: color_fonts_2),
                  textAlign: TextAlign.center,
                ),

                // Espaciado
                SizedBox(height: 20),

                Text(
                  'La página no está disponible por el momento',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
