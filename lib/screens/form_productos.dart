import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final nomprodController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  final stockminimoController = TextEditingController();
  List tiposUnidades = [];
  var idUnidad;
  List tiposCategorias = [];
  var idCategoria;
  bool guardando = false;

  // Variables de diseño (colores)
  Color color_appbar = Color.fromARGB(255, 124, 213, 44);
  Color color_container = Color.fromARGB(130, 124, 213, 44);
  // Color color_bgInputs = Colors.white;
  Color color_effects = Colors.black.withOpacity(0.5);
  // Color color_fonts_1 = Colors.black;
  Color color_fonts_2 = Colors.white;
  Color color_sliderInactive = Colors.grey;
  Color color_sliderOverlay = Color.fromARGB(32, 33, 150, 243);
  Color color_dropdown = Color.fromARGB(220, 124, 213, 44);
  Color color_button1 = Color.fromARGB(255, 70, 160, 30);
  Color color_button2 = Color.fromARGB(255, 4, 33, 49);

  // Imágenes y rutas
  final String bg_img = '../assets/img/bg.jpg';
  final String bg_img2 = '../assets/img/bg_registrer.jpg';

  traerUnidad() async {
    try {
      tiposUnidades = await supabase.from('unidad').select();
      setState(() {});
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Hay un error al traer los datos de unidad',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  traerCategoria() async {
    try {
      tiposCategorias = await supabase.from('categoria').select();
      setState(() {});
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Hay un error al traer los datos de categoría',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    traerUnidad();
    traerCategoria();
  }

  guardarProducto() async {
    try {
      await supabase.from('producto').insert({
        'nom_prod': nomprodController.text,
        'precio': precioController.text,
        'stock': stockController.text,
        'estatus': 'Disponible',
        'stock_minimo': stockminimoController.text,
        'descripcion': descripcionController.text,
        'unidad_id': idUnidad,
        'categoria_id': idCategoria
      });
      Get.snackbar('Guardado', 'Producto Guardado');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'No se pudo guardar',
          backgroundColor: Colors.blueGrey, colorText: Colors.white);
    } finally {
      setState(() {
        guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de encabezado (Appbar)
      appBar: Custom_Appbar(
        titulo: 'Formulario de Productos',
        colorNew: color_appbar,
      ),

      // Cuerpo de la pagina
      body: Stack(
        children: [
          // Fondo 1
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bg_img),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Fondo 2
          Container(
            color: color_effects,
          ),

          // Contenedor principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contenedor de Fondo del Form Products
                    Container(
                      width: 600.0,
                      height: 575.0,
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Input nombre del producto
                            buildTextFormField(
                              controller: nomprodController,
                              labelText: 'Producto',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el nombre del producto';
                                }
                                return null;
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Input descripcion
                            buildTextFormField(
                              controller: descripcionController,
                              labelText: 'Descripcion',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa la descripción del producto';
                                }
                                return null;
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Input precio
                            buildTextFormField(
                              controller: precioController,
                              labelText: 'Precio',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el precio del producto';
                                }
                                return null;
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Input stock
                            buildTextFormField(
                              controller: stockController,
                              labelText: 'Stock',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el stock del producto';
                                }
                                return null;
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Dropdown para seleccionar unidad
                            buildDropdownButtonFormField(
                              labelText: 'Unidad',
                              value: idUnidad,
                              items: tiposUnidades,
                              hint: 'Selecciona una unidad',
                              onChanged: (value) {
                                setState(() {
                                  idUnidad = value;
                                });
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Dropdown para seleccionar categoría
                            buildDropdownButtonFormField(
                              labelText: 'Categoría',
                              value: idCategoria,
                              items: tiposCategorias,
                              hint: 'Selecciona una categoria',
                              onChanged: (value) {
                                setState(() {
                                  idCategoria = value;
                                });
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 16.0),

                            // Input stock minimo
                            buildTextFormField(
                              controller: stockminimoController,
                              labelText: 'Stock Minimo',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa el stock minímo del producto';
                                }
                                return null;
                              },
                            ),

                            // Espaciado
                            SizedBox(height: 20),

                            // Botón para guardar
                            ElevatedButton(
                              onPressed: guardando
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          guardando = true;
                                        });
                                        guardarProducto();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color_button2, // Button color
                                foregroundColor: color_fonts_2, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                guardando ? 'Guardando...' : 'Guardar',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
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

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: color_fonts_2,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color_fonts_2,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color_button2,
            width: 1.0,
          ), // Borde cuando el campo está enfocado
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget buildDropdownButtonFormField({
    required String labelText,
    required dynamic value,
    required List items,
    required String hint,
    required void Function(dynamic) onChanged,
  }) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: color_fonts_2,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color_fonts_2,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color_button2,
            width: 1.0,
          ), // Borde cuando el campo está enfocado
        ),
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e['nom_unidad'] ?? e['nom_cat']),
              ))
          .toList(),
      hint: Text(
        hint,
        style: TextStyle(
            fontSize: 16.0, color: color_fonts_2, fontWeight: FontWeight.bold),
      ),
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down),
      menuMaxHeight: 500,
    );
  }
}
