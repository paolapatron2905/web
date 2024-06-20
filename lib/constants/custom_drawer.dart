import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custom_Drawer extends StatelessWidget {
  const Custom_Drawer({super.key});

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
              child: DrawerHeader(
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
              ),
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
              leading: Icon(Icons.logout_outlined),
              title: Text('Exit'),
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
