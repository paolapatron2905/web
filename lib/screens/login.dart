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
  bool verificar = false;
  final supabase = Supabase.instance.client;
  final formularioKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Color color_container = Color.fromARGB(130, 124, 213, 44);
  Color color_effects = Colors.black.withOpacity(0.5);
  Color color_fonts_1 = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  validarUsuario() async {
    setState(() {
      verificar = true;
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
      print(e);
      Get.snackbar('Error', 'Hubo un error al iniciar sesión',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        verificar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        // Fondo Principal
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/img/bg_login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Fondo Transparente
          Container(
            color: color_effects,
          ),

        // Contenido Principal
          Padding(
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
                        color: color_container,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: color_effects,
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
                                '../assets/img/logo.png',
                                height: 150.0,
                                width: 150.0,
                              ),
                            ),

                          // Espaciado
                            SizedBox(height: 50.0),

                          /* Form Text Correo/Usuario */
                            TextFormField(
                              controller: usernameController,
                              minLines: 1,
                              maxLines: 4,

                            // Estilos del input y derivados
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: 'example@gmail.com',
                                labelText: 'Correo o Usuario',
                                prefixIcon:
                                    Icon(Icons.alternate_email_outlined),
                                labelStyle: TextStyle(
                                  color: color_fonts_1,
                                ),
                              ),

                            // Validación de campo
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo requerido';
                                }
                                return null;
                              },
                            ),

                          // Espaciado
                            SizedBox(height: 20.0),

                          /* Form text Contraseña */
                            TextFormField(
                              controller: passwordController,
                              obscureText: ocultarTexto,

                            // Estilos del input y derivados
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
                                  color: color_fonts_1,
                                ),
                              ),

                            // Validación de campo
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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

                          // Espaciado
                            SizedBox(height: 20.0),

                          /* Boton Iniciar Sesión */
                            ElevatedButton(
                              onPressed: verificar
                                  ? null
                                  : () {
                                      if (formularioKey.currentState!
                                          .validate()) {
                                        print('Inicio de sesión con exito');
                                        validarUsuario();
                                      } else {
                                        print('Error en el inicio de sesión');
                                      }
                                    },
                              child: Text(
                                verificar
                                    ? 'Iniciando Sesión'
                                    : 'Iniciar Sesión',
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
        ],
      ),
    );
  }
}
