import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/models/usuario.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool ocultarTexto = true;
  bool cargando = true;
  final supabase = Supabase.instance.client;
  final formularioKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /* validarUsuario(); */
  }

  validarUsuario() async {
    if (!formularioKey.currentState!.validate()) {
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final response = await supabase
          .from('usuario')
          .select()
          .eq('username', usernameController.text)
          .eq('pass', passwordController.text)
          .single();

      if (response != null) {
        final data = response;
        Usuario usuario = Usuario(
          username: data['username'],
          tipoUsuario: data['tipo_usuario_id'],
        );

        Get.offNamed('/Home', arguments: usuario);
      } else {
        Get.snackbar('Error', 'Usuario o contraseña incorrectos',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al iniciar sesión',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formularioKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 600.0,
                  height: 630.0,
                  decoration: BoxDecoration(
                    color: Colors.green[300]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image.asset(
                            '../assets/logo.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                        SizedBox(height: 50.0),

                        /* Form Text Correo/Usuario */
                        TextFormField(
                          controller: usernameController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: 'example@gmail.com o usuario1',
                            labelText: 'Correo o Usuario',
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),

                        /* Form text Contraseña */
                        TextFormField(
                          controller: passwordController,
                          obscureText: ocultarTexto,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: 'Contraseña',
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(
                                ocultarTexto
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  ocultarTexto = !ocultarTexto;
                                });
                              },
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.trim() == null ||
                                value!.trim().isEmpty) {
                              return 'Campo requerido';
                            }
                            if (value.trim().length < 8) {
                              return 'Contraseña muy corta';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),

                        /* Boton Iniciar Sesión */
                        ElevatedButton(
                          onPressed: () {
                            validarUsuario();
                          },
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
