import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

// Variables de colores
  Color color_container = Color.fromARGB(130, 124, 213, 44);
  Color color_bgInputs = Colors.white;
  Color color_effects = Colors.black.withOpacity(0.5);
  Color color_fonts_1 = Colors.black;
  Color color_fonts_2 = Colors.white;
  Color color_button1 = Color.fromARGB(255, 70, 160, 30);
  Color color_button2 = Color.fromARGB(255, 4, 33, 49);

// Variables de Imagenes
  final String bg_img = '../assets/img/bg_login.jpg';
  final String logo_img = '../assets/img/logo.png';

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

      final data = response;
      String userId =
          data['id'].toString(); // Convertir a String si es necesario

      // Redirige a la página de inicio con el ID del usuario en la URL
      Get.toNamed('/Home/$userId');
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
                image: AssetImage(bg_img),
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
                    // Contenedor del login
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

                      // Campo del logo
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.asset(
                                logo_img,
                                height: 150.0,
                                width: 150.0,
                              ),
                            ),

                            // Espaciado
                            SizedBox(height: 50.0),

                            /* Form Text Correo/Usuario */
                            Container(
                              decoration: BoxDecoration(
                                color: color_bgInputs,
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              // Campo del input
                              child: TextFormField(
                                controller: usernameController,
                                minLines: 1,
                                maxLines: 4,

                                // Estilos del input y derivados de Correo/usuario
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  hintText: 'usuario1234',
                                  labelText: 'Usuario',
                                  prefixIcon: Icon(Icons.person),
                                  labelStyle: TextStyle(
                                    color: color_fonts_1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),

                                // Validación de campo de Correo/usuario
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Espaciado
                            SizedBox(height: 20.0),

                            /* Form text Contraseña */
                            Container(
                              decoration: BoxDecoration(
                                color: color_bgInputs,
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              // Campo del input de contraseña
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: ocultarTexto,

                                // Estilos del input y derivados
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  hintText: '**********',
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
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
                            ),

                            // Espaciado
                            SizedBox(height: 20.0),

                            /* Boton Iniciar Sesión */
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: verificar ? 50.0 : 200.0,
                              height: 50.0,

                              // Logica del boton
                              child: ElevatedButton(
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

                                // Texto del boton estilo
                                child: Text(
                                  verificar
                                      ? 'Iniciando Sesión'
                                      : 'Iniciar Sesión',
                                  style: TextStyle(
                                    color: color_fonts_2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),

                                // Estilos del boton estilo
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: color_button2,
                                ),
                              ),
                            ),

                            // Espaciado
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
