import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
/* import 'package:get/get.dart'; */


class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nom_prodController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _fk_unidadController = TextEditingController();
  final TextEditingController _fk_categoriaController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
      print("Form Submitted");
      print("Producto: ${_nom_prodController.text}");
      print("Descripcion: ${_descripcionController.text}");
      print("Precio: ${_precioController.text}");
      print("Stock: ${_stockController.text}");
      print("Unidad: ${_fk_unidadController.text}");
      print("Categoria: ${_fk_categoriaController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo_pag: 'Iniciar Sesión', colorNew: Colors.green),
      drawer: Custom_Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nom_prodController,
                decoration: InputDecoration(labelText: 'Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la descripción del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el precio del producto';
                  }
                  return null;
                },
              ), 
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Stock'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el stock del producto';
                  }
                  return null;
                },
              ), 
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Unidad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la unidad de medida del producto';
                  }
                  return null;
                },
              ), 
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la categoria del producto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Productos(),
  ));
}
