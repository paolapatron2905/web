import 'package:flutter/material.dart';
// import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario
import 'package:get/get.dart';

class InsertarEmpresa extends StatefulWidget {
  const InsertarEmpresa({super.key});

  @override
  State<InsertarEmpresa> createState() => _InsertarEmpresaState();
}

class _InsertarEmpresaState extends State<InsertarEmpresa> {
  //final args = Get.arguments as Map<String, dynamic>;
  //final usuario = Get.arguments as Usuario;
  final formulario_key = GlobalKey<FormState>();
  final nombre_controller = TextEditingController();
  final supabase = Supabase.instance.client;
  bool guardando = false;

  guardar() async {
    setState(() {
      guardando = true;
    });
    try {
      await supabase
          .from('empresa')
          .insert({'nom_empresa': nombre_controller.text, 'estatus': 'Activo'});
      Get.snackbar('Guardado', 'Empresa guardada correctamente',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al guardar la categoría',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Custom_Appbar(titulo: 'Nueva Empresa', colorNew: Colors.green),
        //drawer: Custom_Drawer(usuario: usuario),
        body: Form(
            key: formulario_key,
            child: Column(
              children: [
                TextFormField(
                  controller: nombre_controller,
                  decoration: InputDecoration(
                      hintText: 'Ingresa el nombre de la empresa'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Completa este campo';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: guardando
                        ? null
                        : () {
                            if (formulario_key.currentState!.validate()) {
                              guardar();
                            } else {
                              print('no okis');
                            }
                          },
                    child: Text(guardando ? 'Guardando' : 'Guardar'))
              ],
            )));
  }
}
