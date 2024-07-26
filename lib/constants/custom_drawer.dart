import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importar la clase Usuario

class Custom_Drawer extends StatelessWidget {
  void _cerrarSesion() {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sistema de Gestión de Inventarios',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ListTile(
              trailing: Icon(Icons.production_quantity_limits_outlined),
              title: Text('Productos'),
              onTap: () {
                Get.toNamed('/tabla');
              },
            ),
            Spacer(),
            ListTile(
              trailing: Icon(Icons.production_quantity_limits_outlined),
              title: Text('Categorías'),
              onTap: () {
                Get.toNamed('/categorias');
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Exit'),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
    );
  }
}
