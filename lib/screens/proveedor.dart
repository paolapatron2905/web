import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario
import 'package:get/get.dart';

class InsertarProveedor extends StatefulWidget {
  const InsertarProveedor({super.key});

  @override
  State<InsertarProveedor> createState() => _InsertarProveedorState();
}

class _InsertarProveedorState extends State<InsertarProveedor> {
  final usuario = Get.arguments as Usuario;
  final formulario_key = GlobalKey<FormState>();
  final nombre_controller = TextEditingController();
  final telefono_controller = TextEditingController();
  final correo_controller = TextEditingController();
  final supabase = Supabase.instance.client;
  bool guardando = false;

  String? estadoSeleccionado;
  String? ciudadSeleccionada;
  Map<String, List<String>> ciudadesPorEstado = {
    'Sinaloa': ['Ahome', 'El Fuerte', 'Choix', 'Mazatlán'],
    'estado 2': [
      'ciudad 1 de estado 2',
      'ciudad 2 de estado 2',
      'ciudad 3 de estado 2',
      'ciudad 4 de estado 2'
    ],
    'estado 3': [
      'ciudad 1 de estado 3',
      'ciudad 2 de estado 3',
      'ciudad 3 de estado 3',
      'ciudad 4 de estado 3'
    ],
    'estado 4': [
      'ciudad 1 de estado 4',
      'ciudad 2 de estado 4',
      'ciudad 3 de estado 4',
      'ciudad 4 de estado 4'
    ],
  };

  guardar() async {
    setState(() {
      guardando = true;
    });
    try {
      await supabase.from('proveedor').insert({
        'nom_proveedor': nombre_controller.text,
        'nom_empresa': 'Empresa Ejemplo',
        'numero': telefono_controller.text,
        'correo': correo_controller.text,
        'ciudad': ciudadSeleccionada ?? 'ciudad ejemplo',
        'estatus': 'Activo'
      });
      Get.snackbar('Guardado', 'Proveedor guardada correctamente',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al guardar al proveedor',
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
        appBar:
            Custom_Appbar(titulo: 'Nuevo Proveedor', colorNew: Colors.green),
        drawer: Custom_Drawer(usuario: usuario),
        body: Form(
            key: formulario_key,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nombre_controller,
                    decoration: InputDecoration(
                        hintText: 'Ingresa el nombre del proveedor'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Completa este campo';
                      }
                    },
                  ),
                  TextFormField(
                    controller: telefono_controller,
                    decoration:
                        InputDecoration(hintText: 'Ingresa el teléfono'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Completa este campo';
                      }
                    },
                  ),
                  TextFormField(
                    controller: correo_controller,
                    decoration: InputDecoration(hintText: 'Ingresa el correo'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Completa este campo';
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: estadoSeleccionado,
                    hint: Text('Selecciona un estado'),
                    items: ciudadesPorEstado.keys.map((String estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        estadoSeleccionado = newValue;
                        ciudadSeleccionada = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona un estado' : null,
                  ),
                  if (estadoSeleccionado != null)
                    DropdownButtonFormField<String>(
                      value: ciudadSeleccionada,
                      hint: Text('Selecciona una ciudad'),
                      items: ciudadesPorEstado[estadoSeleccionado]!
                          .map((String ciudad) {
                        return DropdownMenuItem<String>(
                          value: ciudad,
                          child: Text(ciudad),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          ciudadSeleccionada = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecciona una ciudad' : null,
                    ),
                  ElevatedButton(
                      onPressed: guardando
                          ? null
                          : () {
                              if (formulario_key.currentState!.validate()) {
                                guardar();
                              } else {
                                print('Formulario incompleto');
                              }
                            },
                      child: Text(guardando ? 'Guardando' : 'Guardar')),
                  if (estadoSeleccionado != null && ciudadSeleccionada != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                          'Seleccionado: $ciudadSeleccionada, $estadoSeleccionado'),
                    ),
                ],
              ),
            )));
  }
}
