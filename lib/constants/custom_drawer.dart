import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(child: Icon(Icons.home)),
            ListTile(
              leading: Icon(Icons.access_time_filled_sharp),
              title: Text('Ejemplo'),
              subtitle: Text('Descripción'),
              onTap: () {
                Get.toNamed('/');
              },
            ),
            ListTile(
              trailing: Icon(Icons.access_time_filled_sharp),
              title: Text('Ejemplo'),
              onTap: () {
                Get.toNamed('/Ejemplo');
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time_filled_sharp),
              title: Text('Ejemplo'),
              onTap: () {
                //funcion vacía
              },
            ),
            ListTile(
              trailing: Icon(Icons.access_time_filled_sharp),
              title: Text('Figura1'),
              onTap: () {
                Get.toNamed('/Figura1');
              },
            ),
            ListTile(
              trailing: Icon(Icons.access_time_filled_sharp),
              title: Text('Imagenes de perritos'),
              onTap: () {
                Get.toNamed('/Perro');
              },
            ),
            ListTile(
              trailing: Icon(Icons.access_time_filled_sharp),
              title: Text('Responsivo'),
              onTap: () {
                Get.toNamed('/OtroResponsivo');
              },
            ),
            ListTile(
              trailing: Icon(Icons.login_outlined),
              title: Text('Iniciar Sesión'),
              onTap: () {
                Get.toNamed('/login');
              },
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.access_time_filled_sharp),
              title: Text('Ejemplo'),
              onTap: () {
                //funcion vacía
              },
            ),
          ],
        ),
      ),
    );
  }
}
