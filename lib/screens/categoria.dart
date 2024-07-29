import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class InsertarCategoria extends StatefulWidget {
  const InsertarCategoria({super.key});

  @override
  State<InsertarCategoria> createState() => _InsertarCategoriaState();
}

class _InsertarCategoriaState extends State<InsertarCategoria> {
  final formulario_key = GlobalKey<FormState>();
  final nombre_controller = TextEditingController();
  final supabase = Supabase.instance.client;
  bool guardando = false;

  Future<void> guardar() async {
    setState(() {
      guardando = true;
    });
    try {
      await supabase
          .from('categoria')
          .insert({'nom_cat': nombre_controller.text});
      Get.snackbar('Guardado', 'Categoría guardada correctamente',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al guardar la categoría',
          backgroundColor: Colors.red, colorText: Colors.white);
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
        titulo: 'Nueva Categoría',
        colorNew: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formulario_key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nombre_controller,
                decoration: InputDecoration(
                  hintText: 'Ingresa una categoría',
                  labelText: 'Nombre de la Categoría',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Completa este campo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardando
                    ? null
                    : () {
                        if (formulario_key.currentState!.validate()) {
                          guardar();
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
}
