import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario

class Custom_Drawer extends StatelessWidget {
  final Usuario usuario; // Agregar un argumento para el usuario

  const Custom_Drawer({super.key, required this.usuario});

  void _cerrarSesion() {
    // Aquí puedes limpiar cualquier dato de sesión almacenado localmente

    // Redirigir al usuario a la pantalla de inicio de sesión
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
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
            // Mostrar opciones basadas en el tipo de usuario
            if (usuario.tipoUsuario == 1)
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Opciones de Administrador'),
                onTap: () {
                  // Lógica para opciones de administrador
                },
              )
            else if (usuario.tipoUsuario == 2)
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Opciones para Usuario'),
                onTap: () {
                  // Lógica para opciones de usuario
                },
              ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Exit'),
              onTap: _cerrarSesion, // Llamada a la función de cerrar sesión
            ),
          ],
        ),
      ),
    );
  }
}
