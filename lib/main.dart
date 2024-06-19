import 'package:flutter/material.dart';
import 'package:inventario/screens/ejemplo.dart';
import 'package:get/get.dart';
import 'package:inventario/screens/otroarchivo.dart';
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
      title: 'Prueba',
      //home: Plantilla(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Ejemplo()),
        GetPage(name: '/Otro', page: () => OtroEjemplo()),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    ); //borrar etiqueta debug
  }
}
