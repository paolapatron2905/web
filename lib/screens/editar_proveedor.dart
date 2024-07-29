import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/constants/custom_appbar.dart';

class EditarProveedorPage extends StatefulWidget {
  @override
  _EditarProveedorPageState createState() => _EditarProveedorPageState();
}

class _EditarProveedorPageState extends State<EditarProveedorPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> proveedor;
  late TextEditingController nomController;
  late TextEditingController telefonoController;
  late TextEditingController correoController;
  late TextEditingController direccionController;
  late String proveedorId;
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  Color color_fonts_2 = Colors.white;

  @override
  void initState() {
    super.initState();
    proveedorId = Get.parameters['id']!;
    proveedor = _fetchProveedor(proveedorId);
  }

  Future<Map<String, dynamic>> _fetchProveedor(String id) async {
    final response =
        await supabase.from('proveedor').select().eq('id', id).single();
    final data = Map<String, dynamic>.from(response);
    nomController = TextEditingController(text: data['nom_proveedor']);
    telefonoController = TextEditingController(text: data['telefono']);
    correoController = TextEditingController(text: data['correo']);
    direccionController = TextEditingController(text: data['direccion']);
    return data;
  }

  Future<void> _updateProveedor() async {
    await supabase.from('proveedor').update({
      'nom_proveedor': nomController.text,
      'telefono': telefonoController.text,
      'correo': correoController.text,
      'direccion': direccionController.text,
    }).eq('id', proveedorId);
    Get.back(); // Return to previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Editar Proveedor',
        colorNew: color_container,
        textColor: color_fonts_2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: proveedor,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontró el proveedor'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color for form
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 124, 213, 44),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: telefonoController,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 124, 213, 44),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: correoController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 124, 213, 44),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: direccionController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 124, 213, 44),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateProveedor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromARGB(255, 124, 213, 44), // Button color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
