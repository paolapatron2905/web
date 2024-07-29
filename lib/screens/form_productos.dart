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
      appBar: Custom_Appbar(
        titulo: 'Formulario de Productos',
        colorNew: Colors.green,
      ),
      // drawer: Custom_Drawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 20),
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
                  backgroundColor: Colors.green, // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  guardando ? 'Guardando...' : 'Guardar',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
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
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e['nom_unidad'] ?? e['nom_cat']),
              ))
          .toList(),
      hint: Text(hint),
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down),
      menuMaxHeight: 500,
    );
  }
}
