import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/screens/producto_proveedor.dart';
import 'package:inventario/screens/productos.dart';
import 'package:inventario/screens/categoria.dart';
import 'package:inventario/screens/home.dart';
import 'package:inventario/screens/login.dart';
import 'package:inventario/screens/proveedor.dart';
import 'package:inventario/screens/select.dart';
import 'package:inventario/screens/tabla.dart';
import 'package:inventario/screens/usuarios.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://zdshwmpzzpcdbfhmrbgh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpkc2h3bXB6enBjZGJmaG1yYmdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgzNzkwNDEsImV4cCI6MjAzMzk1NTA0MX0.raI9WJZeb98R2Px3mGnzTugBUQOt9srnAq97oPMVY5c',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inicia Sesión',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Login()),
        GetPage(name: '/producto_proveedor', page: () => ProductoProveedor()),
        GetPage(name: '/tabla', page: () => Ejemplo()),
        GetPage(name: '/NuevaCategoria', page: () => InsertarCategoria()),
        GetPage(name: '/NuevoProveedor', page: () => InsertarProveedor()),
        GetPage(name: '/Select', page: () => Select()),
        GetPage(name: '/Usuario', page: () => InsertarUsuario()),
        GetPage(name: '/Home', page: () => Home()),
        GetPage(name: '/productos', page: () => Productos())
        /* GetPage(name: '/login', page: () => ), */
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    ); //borrar etiqueta debug
  }
}
