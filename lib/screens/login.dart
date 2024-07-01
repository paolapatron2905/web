import 'package:flutter/material.dart';
/* import 'package:flutter/widgets.dart'; */
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool ocultarTexto = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Custom_Appbar(titulo_pag: 'Iniciar Sesión', colorNew: Colors.green),
      drawer: Custom_Drawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 590.0,
                height: 600.0,
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
                      SizedBox(height: 30.0),
                      Text(
                        'Iniciar Sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),

                      /* Form Text Correo/Usuario */
                      TextFormField(
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
                          if (!value.isEmail) {
                            return 'Correo no valido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),

                      /* Form text Contraseña */
                      TextFormField(
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
                          if (value?.trim() == null || value!.trim().isEmpty) {
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
                          Get.toNamed('/dashboard');
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          /* primary: Colors.yellow[200], */
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
    );
  }
}
