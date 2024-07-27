import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custom_Drawer extends StatelessWidget {
  void _cerrarSesion() {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(child: Icon(Icons.home)),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Ver inventario'),
              onTap: () {
                Get.toNamed('/tabla');
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categorías'),
              onTap: () {
                Get.toNamed('/categorias');
              },
            ),
            ListTile(
              leading: Icon(Icons.business_center),
              title: Text('Proveedores'),
              onTap: () {
                Get.toNamed('/NuevoProveedor');
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Empresas'),
              onTap: () {
                Get.toNamed('/NuevaEmpresa');
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Reportes'),
              onTap: () {
                Get.toNamed('/Reportes');
              },
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
    );
  }
}
