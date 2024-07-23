import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custom_Drawer extends StatelessWidget {
  /*void _cerrarSesion() {
    Get.offAllNamed('/login');
  }*/

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
              /* child: Image.asset(
                'assets/images/logo.png',
                height: 100,
                width: 100,
              ),
             */
              /*child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Stack(
                  children: [
                    /* Positioned.fill(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ), */
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
              ),*/
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Opciones de Administrador'),
              onTap: () {
                // Lógica para opciones de administrador
              },
            ),
            ListTile(
              trailing: Icon(Icons.production_quantity_limits_outlined),
              title: Text('Productos'),
              onTap: () {
                Get.toNamed('/tabla');
              },
            ),
            Spacer(),
            ListTile(
              trailing: Icon(Icons.person),
              title: Text('Usuarios'),
              onTap: () {
                Get.toNamed('/Usuario');
              },
            ),
            Spacer(),
            ListTile(
              trailing: Icon(Icons.add),
              title: Text('Categorias'),
              onTap: () {
                Get.toNamed('/NuevaCategoria');
              },
            ),
            Spacer(),
            ListTile(
              trailing: Icon(Icons.agriculture),
              title: Text('Proveedores'),
              onTap: () {
                Get.toNamed('/NuevoProveedor');
              },
            ),
            Divider(),
            /*ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Exit'),
              onTap: _cerrarSesion,
            ),*/
          ],
        ),
      ),
    );
  }
}
