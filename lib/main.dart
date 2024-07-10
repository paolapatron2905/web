import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/screens/form_producto.dart';
import 'package:inventario/screens/form_productos.dart';
import 'package:inventario/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://cakpxhdvkbqsemsrujcy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNha3B4aGR2a2Jxc2Vtc3J1amN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkyNTU3MDIsImV4cCI6MjAzNDgzMTcwMn0.SFbWH45-7hsMkbgD991s351NZMMnrG8OPEyyoPhU5bo',
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
        GetPage(name: '/productos', page: () => Productos()),
        GetPage(name: '/productos_1', page: () => Productos_1()),
        /* GetPage(name: '/login', page: () => ), */
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    ); //borrar etiqueta debug
  }
}
