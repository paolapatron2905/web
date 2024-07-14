import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
// import 'package:inventario/constants/custom_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final form_key = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final nomprod_Controller = TextEditingController();
  final descripcion_Controller = TextEditingController();
  final precio_Controller = TextEditingController();
  final stock_Controller = TextEditingController();
  final stockminimo_Controller = TextEditingController();
  List tiposUnidades = [];
  var idUnidad;
  List tiposCategorias = [];
  var idCategoria;
  bool guardando = false;

  traerUnidad() async {
    try {
      tiposUnidades = await supabase.from('unidad').select();
      print('----------------------');
      print(tiposUnidades);

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
      print('----------------------');
      print(tiposCategorias);

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
    print('-----------------');
    traerUnidad();
    traerCategoria();
  }

  guardarProducto() async {
    try {
      await supabase.from('producto').insert({
        'nom_prod': nomprod_Controller.text,
        'precio': precio_Controller.text,
        'stock': stock_Controller.text,
        'estatus': 'Activo',
        'stock_minimo': stockminimo_Controller.text,
        'descripcion': descripcion_Controller.text,
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
      //drawer: Custom_Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: form_key,
          child: Column(
            children: [
              TextFormField(
                controller: nomprod_Controller,
                decoration: InputDecoration(
                  labelText: 'Producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descripcion_Controller,
                decoration: InputDecoration(
                  labelText: 'Descripcion',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la descripción del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: precio_Controller,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el precio del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: stock_Controller,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el stock del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Unidad',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Selecciona una unidad'),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                menuMaxHeight: 500,
                value: idUnidad,
                items: tiposUnidades
                    .map((e) => DropdownMenuItem(
                          value: e['id'],
                          child: Text(e['nom_unidad']),
                        ))
                    .toList(),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    idUnidad = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Selecciona una categoria'),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                menuMaxHeight: 500,
                value: idCategoria,
                items: tiposCategorias
                    .map((e) => DropdownMenuItem(
                          value: e['id'],
                          child: Text(e['nom_cat']),
                        ))
                    .toList(),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    idCategoria = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: stockminimo_Controller,
                decoration: InputDecoration(
                  labelText: 'Stock Minimo',
                  border: OutlineInputBorder(),
                ),
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
                        if (form_key.currentState!.validate()) {
                          print('Guardado');
                          setState(() {
                            guardando = true;
                          });
                          guardarProducto();
                        } else {
                          print(
                              'No se ha podido guardar el registro del producto');
                        }
                      },
                child: Text(guardando ? 'Guardando' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
