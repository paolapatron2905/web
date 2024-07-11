import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/custom_appbar.dart';
//import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertarUsuario extends StatefulWidget {
  const InsertarUsuario({super.key});

  @override
  State<InsertarUsuario> createState() => _InsertarUsuarioState();
}

class _InsertarUsuarioState extends State<InsertarUsuario> {
  //final usuario = Get.arguments as Usuario;
  bool ver = true;
  bool guardando = false;
  bool cargandoTiposUsuario = true;
  final supabase = Supabase.instance.client;
  final formularioKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  int? tipoUsuarioSeleccionado;
  List<Map<String, dynamic>> tiposUsuario = [];

  @override
  void initState() {
    super.initState();
    cargarTiposUsuario();
  }

  cargarTiposUsuario() async {
    setState(() {
      cargandoTiposUsuario = true;
    });
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('tipo_usuario').select();
      setState(() {
        tiposUsuario = response;
      });
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al cargar los tipos de usuario',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error: $e');
    } finally {
      setState(() {
        cargandoTiposUsuario = false;
      });
    }
  }

  guardarUsuario() async {
    setState(() {
      guardando = true;
    });

    try {
      final userExists = await supabase
          .from('usuario')
          .select()
          .eq('username', usernameController.text);

      if (userExists.isNotEmpty) {
        Get.snackbar('Error', 'El usuario ya existe',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        await supabase.from('usuario').insert({
          'username': usernameController.text,
          'pass': passwordController.text,
          'tipo_usuario_id': tipoUsuarioSeleccionado
        });

        Get.snackbar('Guardado', 'Usuario guardado correctamente',
            backgroundColor: Colors.green, colorText: Colors.white);
        limpiarFormulario();
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al guardar el usuario',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        guardando = false;
      });
    }
  }

  limpiarFormulario() {
    usernameController.clear();
    passwordController.clear();
    setState(() {
      tipoUsuarioSeleccionado = null;
    });
    formularioKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Nuevo Usuario', colorNew: Colors.green),
      //drawer: Custom_Drawer(usuario: usuario),
      body: cargandoTiposUsuario
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formularioKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: 'Ingresa un nombre de usuario'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Completa este campo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        controller: passwordController,
                        autocorrect: false,
                        autofocus: false,
                        cursorColor: Colors.pink,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.phone,
                        obscureText: ver,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Contraseña',
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(ver
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                ver = !ver;
                                setState(() {});
                              },
                            ))),
                    DropdownButtonFormField<int>(
                      value: tipoUsuarioSeleccionado,
                      decoration: InputDecoration(
                          hintText: 'Selecciona tipo de usuario'),
                      items: tiposUsuario.map((tipo) {
                        return DropdownMenuItem<int>(
                          value: tipo['id'],
                          child: Text(tipo['nom_tipo']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          tipoUsuarioSeleccionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un tipo de usuario';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: guardando
                          ? null
                          : () {
                              if (formularioKey.currentState!.validate()) {
                                guardarUsuario();
                              }
                            },
                      child: Text(guardando ? 'Guardando' : 'Guardar'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
