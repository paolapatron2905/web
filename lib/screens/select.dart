import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario
import 'package:get/get.dart';

class Select extends StatefulWidget {
  const Select({super.key});

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  final usuario = Get.arguments as Usuario;
  final formulario_key = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  bool guardando = false;

  String? categoriaSeleccionada;
  //Arreglo con categorías
  List<String> categorias = [
    'Categoría 1',
    'Categoría 2',
    'Categoría 3',
    'Categoría 4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Custom_Appbar(
            titulo: 'Select categorías ejemplo', colorNew: Colors.green),
        drawer: Custom_Drawer(usuario: usuario),
        body: Form(
            key: formulario_key,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Empieza select
                  DropdownButtonFormField<String>(
                    value: categoriaSeleccionada,
                    hint: Text('Selecciona una categoría'),
                    items: categorias.map((String categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        categoriaSeleccionada = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona una categoría' : null,
                  ),
                  //Termine select
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    //Imprimimos la categoría para comprobar que la variable toma el valor seleccionado
                    child: Text('Seleccionado:  $categoriaSeleccionada'),
                  ),
                ],
              ),
            )));
  }
}
