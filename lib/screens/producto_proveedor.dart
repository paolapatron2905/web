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
      setState(() {});
    } catch (e) {
      Get.snackbar('Error', 'Hay un error al traer los datos de producto',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  traerProveedor() async {
    try {
      nomProveedor = await supabase.from('proveedor').select();
      setState(() {});
    } catch (e) {
      Get.snackbar('Error', 'Hay un error al traer los datos del proveedor',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdown(
                labelText: 'Producto',
                hint: 'Selecciona el producto que se enlazará al proveedor',
                value: idProducto,
                items: nomProducto,
                itemLabel: 'nom_prod',
                onChanged: (value) {
                  setState(() {
                    idProducto = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              _buildDropdown(
                labelText: 'Proveedor',
                hint: 'Selecciona el proveedor',
                value: idProveedor,
                items: nomProveedor,
                itemLabel: 'nom_proveedor',
                onChanged: (value) {
                  setState(() {
                    idProveedor = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardando
                    ? null
                    : () {
                        if (form_key.currentState!.validate()) {
                          setState(() {
                            guardando = true;
                          });
                          guardarProducto();
                        } else {
                          Get.snackbar(
                              'Error', 'No se ha podido guardar el registro',
                              backgroundColor: Colors.orange,
                              colorText: Colors.white);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(guardando ? 'Guardando...' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required String hint,
    required dynamic value,
    required List<dynamic> items,
    required String itemLabel,
    required ValueChanged<dynamic> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(hint),
          icon: Icon(Icons.arrow_drop_down),
          isExpanded: true,
          menuMaxHeight: 500,
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                    value: e['id'],
                    child: Text(e[itemLabel]),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
