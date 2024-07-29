import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custom_Drawer extends StatelessWidget {
  // Variables de diseño (colores)
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  Color color_appbar = Color.fromARGB(255, 44, 111, 127);
  // Color color_bgInputs = Colors.white;
  Color color_effects = Colors.black.withOpacity(0.5);
  // Color color_fonts_1 = Colors.black;
  Color color_fonts_2 = Colors.white;
  Color color_button1 = Color.fromARGB(255, 70, 160, 30);
  Color color_button2 = Color.fromARGB(255, 4, 33, 49);

  void _cerrarSesion() {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: color_container,
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.eco_sharp,
                color: color_button2,
                size: 100,
              ),
            ),

            // Ver inventario
            ListTile(
              leading: Icon(
                Icons.inventory,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Ver inventario',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: () {
                Get.toNamed('/tabla');
              },
            ),

            // Categorias
            ListTile(
              leading: Icon(
                Icons.category,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Categorías',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: () {
                Get.toNamed('/categorias');
              },
            ),

            // Proveedores
            ListTile(
              leading: Icon(
                Icons.business_center,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Proveedores',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: () {
                Get.toNamed('/Proveedor');
              },
            ),

            // Empresas
            ListTile(
              leading: Icon(
                Icons.business,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Empresas',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: () {
                Get.toNamed('/Empresas');
              },
            ),

            // Reportes
            ListTile(
              leading: Icon(
                Icons.bar_chart,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Reportes',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: () {
                Get.toNamed('/Reportes');
              },
            ),

            // Espaciado
            Spacer(),

            // Divisor
            Divider(),

            // Cerrar sesión
            ListTile(
              leading: Icon(
                Icons.logout,
                color: color_button2,
                size: 30,
              ),
              title: Text(
                'Salir',
                style: TextStyle(color: color_fonts_2),
              ),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
    );
  }
}
