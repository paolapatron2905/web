import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/constants/custom_appbar.dart';

class ProveedoresPage extends StatefulWidget {
  @override
  _ProveedoresPageState createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> proveedores;
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  Color color_fonts_2 = Colors.white;

  @override
  void initState() {
    super.initState();
    proveedores = _fetchProveedores();
  }

  Future<List<Map<String, dynamic>>> _fetchProveedores() async {
    final response = await supabase.from('proveedor').select(
        'id, nom_proveedor, telefono, correo, direccion, empresa(nom_empresa), ciudad(nom_ciudad)');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Proveedores',
        colorNew: color_container,
        textColor: color_fonts_2,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: proveedores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay proveedores disponibles'));
          }

          final proveedoresData = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/img/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Nombre',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Teléfono',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Correo',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Dirección',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Empresa',
                                  style: TextStyle(color: Colors.white))),
                          DataColumn(
                              label: Text('Ciudad',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        rows: proveedoresData.map((proveedor) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                  proveedor['nom_proveedor'] ?? 'No disponible',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  proveedor['telefono'] ?? 'No disponible',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  proveedor['correo'] ?? 'No disponible',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  proveedor['direccion'] ?? 'No disponible',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  proveedor['empresa']?['nom_empresa'] ??
                                      'No disponible',
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  proveedor['ciudad']?['nom_ciudad'] ??
                                      'No disponible',
                                  style: TextStyle(color: Colors.white))),
                            ],
                            onSelectChanged: (selected) {
                              if (selected != null && selected) {
                                Get.toNamed('/EditarProveedor', parameters: {
                                  'id': proveedor['id'].toString()
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Get.toNamed('/NuevoProveedor');
                        },
                        child: Icon(Icons.add),
                        heroTag: null, // Avoid hero tag conflict
                        tooltip: 'Crear Nuevo Proveedor',
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton(
                        onPressed: () {
                          Get.toNamed('/ProductoProveedor');
                        },
                        child: Icon(Icons.link),
                        heroTag: null, // Avoid hero tag conflict
                        tooltip: 'Ligar Proveedor con Productos',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
