import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProductoDetalle extends StatefulWidget {
  @override
  _ProductoDetalleState createState() => _ProductoDetalleState();
}

class _ProductoDetalleState extends State<ProductoDetalle> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> producto;
  late Future<List<Map<String, dynamic>>> entradas;
  late Future<List<Map<String, dynamic>>> salidas;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  // El controlador de stock ya no se necesita para edición

  @override
  void initState() {
    super.initState();
    final int productoId = int.parse(Get.parameters['id']!);
    producto = _fetchProducto(productoId);
    entradas = _fetchEntradas(productoId);
    salidas = _fetchSalidas(productoId);

    // Inicializar los controladores
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _precioController = TextEditingController();
  }

  Future<Map<String, dynamic>> _fetchProducto(int id) async {
    final response = await supabase
        .from('producto')
        .select('id, nom_prod, descripcion, precio, stock, estatus')
        .eq('id', id)
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> _fetchEntradas(int id) async {
    final response = await supabase
        .from('producto_entrada')
        .select('cantidad, created_at')
        .eq('producto_id', id);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> _fetchSalidas(int id) async {
    final response = await supabase
        .from('producto_saliente')
        .select('cantidad, created_at')
        .eq('producto_id', id);
    return List<Map<String, dynamic>>.from(response);
  }

  void _toggleEstatus(int productoId, String estatusActual) async {
    final nuevoEstatus =
        estatusActual == 'Disponible' ? 'No disponible' : 'Disponible';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Confirmar cambio de estatus'),
        content: Text(
            '¿Está seguro de que desea cambiar el estatus a $nuevoEstatus?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await supabase
            .from('producto')
            .update({'estatus': nuevoEstatus}).eq('id', productoId);
        setState(() {
          producto = _fetchProducto(productoId);
        });
        Get.snackbar('Éxito', 'Estatus actualizado correctamente');
      } catch (e) {
        Get.snackbar('Error', 'Error al actualizar el estatus');
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('d MMMM yyyy', 'es_ES').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final productoId = int.parse(Get.parameters['id']!);
              final productoData = await producto;
              _toggleEstatus(productoId, productoData['estatus']);
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: producto,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No hay datos disponibles'));
          }

          final productoData = snapshot.data!;
          _nombreController.text = productoData['nom_prod'];
          _descripcionController.text = productoData['descripcion'];
          _precioController.text = productoData['precio'].toString();
          // El stock no se edita

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEditing)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(labelText: 'Nombre'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese el nombre' : null,
                        ),
                        TextFormField(
                          controller: _descripcionController,
                          decoration: InputDecoration(labelText: 'Descripción'),
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese la descripción' : null,
                        ),
                        TextFormField(
                          controller: _precioController,
                          decoration: InputDecoration(labelText: 'Precio'),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese el precio' : null,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final updatedProduct = {
                                'nom_prod': _nombreController.text,
                                'descripcion': _descripcionController.text,
                                'precio': double.parse(_precioController.text),
                                // El stock no se actualiza
                              };
                              _updateProducto(int.parse(Get.parameters['id']!),
                                  updatedProduct);
                            }
                          },
                          child: Text('Actualizar'),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${productoData['nom_prod']}'),
                      Text('Descripción: ${productoData['descripcion']}'),
                      Text('Precio: \$${productoData['precio']}'),
                      Text('Stock: ${productoData['stock']}'),
                      Text('Estatus: ${productoData['estatus']}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: Text(isEditing ? 'Cancelar' : 'Editar'),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text('Entradas'),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: entradas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error al cargar entradas'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No hay entradas disponibles'));
                    }

                    final entradasData = snapshot.data!;

                    return DataTable(
                      columns: [
                        DataColumn(label: Text('Cantidad')),
                        DataColumn(label: Text('Fecha')),
                      ],
                      rows: entradasData.map((entrada) {
                        final fecha = DateTime.parse(entrada['created_at']);
                        return DataRow(
                          cells: [
                            DataCell(Text(entrada['cantidad'].toString())),
                            DataCell(Text(_formatDateTime(fecha))),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text('Salidas'),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: salidas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error al cargar salidas'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No hay salidas disponibles'));
                    }

                    final salidasData = snapshot.data!;

                    return DataTable(
                      columns: [
                        DataColumn(label: Text('Cantidad')),
                        DataColumn(label: Text('Fecha')),
                      ],
                      rows: salidasData.map((salida) {
                        final fecha = DateTime.parse(salida['created_at']);
                        return DataRow(
                          cells: [
                            DataCell(Text(salida['cantidad'].toString())),
                            DataCell(Text(_formatDateTime(fecha))),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateProducto(
      int productoId, Map<String, dynamic> updatedProduct) async {
    try {
      await supabase
          .from('producto')
          .update(updatedProduct)
          .eq('id', productoId);
      setState(() {
        producto = _fetchProducto(productoId);
        isEditing = false;
      });
      Get.snackbar('Éxito', 'Producto actualizado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'Error al actualizar el producto');
    }
  }

  @override
  void dispose() {
    // Limpiar los controladores al destruir el widget
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }
}
