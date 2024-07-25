import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/constant.dart';
import 'package:inventario/screens/categoria.dart';
import 'package:inventario/screens/detalle_categoria.dart';
import 'package:inventario/screens/empresa.dart';
import 'package:inventario/screens/form_productos.dart';
import 'package:inventario/screens/home.dart';
import 'package:inventario/screens/login.dart';
import 'package:inventario/screens/pedido.dart';
import 'package:inventario/screens/producto_proveedor.dart';
import 'package:inventario/screens/proveedor.dart';
import 'package:inventario/screens/reporte.dart';
import 'package:inventario/screens/tabla.dart';
import 'package:inventario/screens/usuarios.dart';
import 'package:inventario/screens/categorias.dart';
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
      title: 'AgroInvent',
      initialRoute: client.auth.currentSession != null ? '/Home' : '/',
      getPages: [
        GetPage(name: '/', page: () => Login()),
        GetPage(name: '/Home/:userId', page: () => Home()),
        GetPage(name: '/Usuario', page: () => InsertarUsuario()),
        GetPage(name: '/tabla', page: () => Ejemplo()),
        GetPage(name: '/NuevaCategoria', page: () => InsertarCategoria()),
        GetPage(name: '/NuevaEmpresa', page: () => InsertarEmpresa()),
        GetPage(name: '/Usuario', page: () => InsertarUsuario()),
        GetPage(name: '/pedido/:userId/:productId', page: () => Pedido()),
        GetPage(name: '/productos', page: () => Productos()),
        GetPage(name: '/NuevoProveedor', page: () => InsertarProveedor()),
        GetPage(name: '/ProductoProveedor', page: () => ProductoProveedor()),
        GetPage(name: '/Reportes', page: () => Reporte()),
        GetPage(name: '/categorias', page: () => Categorias()),
        GetPage(
            name: '/detalle_categoria/:categoryId',
            page: () => DetalleCategoria()),
        /* GetPage(name: '/login', page: () => ), */
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    ); //borrar etiqueta debug
  }
}
