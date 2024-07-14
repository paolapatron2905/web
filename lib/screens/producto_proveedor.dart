import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
// import 'package:inventario/constants/custom_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class ProductoProveedor extends StatefulWidget {
  const ProductoProveedor({super.key});

  @override
  State<ProductoProveedor> createState() => _ProductoProveedorState();
}

class _ProductoProveedorState extends State<ProductoProveedor> {
  final form_key = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  List nomProducto = [];
  var idProducto;
  List nomProveedor = [];
  var idProveedor;

  bool guardando = false;

  traerProducto() async {
    try {
      nomProducto = await supabase.from('producto').select();
      print('----------------------');
      print(nomProducto);

      setState(() {});
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Hay un error al traer los datos de producto',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  traerProveedor() async {
    try {
      nomProveedor = await supabase.from('proveedor').select();
      print('----------------------');
      print(nomProveedor);

      setState(() {});
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Hay un error al traer los datos del proveedor',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    print('-----------------');
    traerProducto();
    traerProveedor();
  }

  guardarProducto() async {
    try {
      await supabase.from('producto_proveedor').insert({
        'producto_id': idProducto,
        'proveedor_id': idProveedor,
        'estatus': 'Activo'
        // Make sure to add the unit ID
      });
      Get.snackbar('Guardado',
          'El producto se ha enlazado con el proveedor y ha sido guardado');
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
          titulo: 'Formulario de Productos', colorNew: Colors.green),
      //drawer: Custom_Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: form_key,
          child: Column(
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Producto',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text(
                        'Selecciona el producto que se enlazará al proveedor'),
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    menuMaxHeight: 500,
                    value: idProducto,
                    items: nomProducto
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['nom_prod']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        idProducto = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Proveedor',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: Text('Selecciona el proveedor'),
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    menuMaxHeight: 500,
                    value: idProveedor,
                    items: nomProveedor
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['nom_proveedor']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        idProveedor = value;
                      });
                    },
                  ),
                ),
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
                          print('No se ha podido guardar el registro');
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
