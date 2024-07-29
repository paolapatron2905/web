import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:inventario/constants/custom_appbar.dart';

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
  final String bg_img = '../assets/img/bg.jpg';
  Color color_effects = Colors.black.withOpacity(0.5);
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  Color color_fonts_2 = Colors.white;

  @override
  void initState() {
    super.initState();
    final int productoId = int.parse(Get.parameters['id']!);
    producto = _fetchProducto(productoId);
    entradas = _fetchEntradas(productoId);
    salidas = _fetchSalidas(productoId);

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
      appBar: Custom_Appbar(
        titulo: 'Detalle del Producto',
        colorNew: color_container,
        textColor: color_fonts_2,
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

          return Stack(
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
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detalles del producto y botones de acción
                    Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isEditing)
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _nombreController,
                                    decoration:
                                        InputDecoration(labelText: 'Nombre'),
                                    validator: (value) => value!.isEmpty
                                        ? 'Ingrese el nombre'
                                        : null,
                                  ),
                                  TextFormField(
                                    controller: _descripcionController,
                                    decoration: InputDecoration(
                                        labelText: 'Descripción'),
                                    validator: (value) => value!.isEmpty
                                        ? 'Ingrese la descripción'
                                        : null,
                                  ),
                                  TextFormField(
                                    controller: _precioController,
                                    decoration:
                                        InputDecoration(labelText: 'Precio'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? 'Ingrese el precio'
                                        : null,
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final updatedProduct = {
                                          'nom_prod': _nombreController.text,
                                          'descripcion':
                                              _descripcionController.text,
                                          'precio': double.parse(
                                              _precioController.text),
                                        };
                                        _updateProducto(
                                            int.parse(Get.parameters['id']!),
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
                                _buildDetailRow(
                                    'Nombre', productoData['nom_prod']),
                                _buildDetailRow(
                                    'Descripción', productoData['descripcion']),
                                _buildDetailRow(
                                    'Precio', '\$${productoData['precio']}'),
                                _buildDetailRow(
                                    'Stock', '${productoData['stock']}'),
                                _buildDetailRow(
                                    'Estatus', '${productoData['estatus']}'),
                                SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Botón de cambiar disponibilidad
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            child: Text(isEditing ? 'Cancelar' : 'Editar'),
                          ),
                          SizedBox(height: 16), // Espacio entre los botones
                          ElevatedButton(
                            onPressed: () async {
                              final productoId =
                                  int.parse(Get.parameters['id']!);
                              final productoData = await producto;
                              _toggleEstatus(
                                  productoId, productoData['estatus']);
                            },
                            child: Text('Cambiar Disponibilidad'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    // Sección de movimientos
                    Center(
                      child: Text(
                        'Movimientos',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth > 600;
                        return isWideScreen
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildMovimientosTable(
                                      title: 'Entradas',
                                      futureData: entradas,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: _buildMovimientosTable(
                                      title: 'Salidas',
                                      futureData: salidas,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildMovimientosTable(
                                    title: 'Entradas',
                                    futureData: entradas,
                                  ),
                                  SizedBox(height: 20),
                                  _buildMovimientosTable(
                                    title: 'Salidas',
                                    futureData: salidas,
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String fieldName, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              fieldName,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovimientosTable({
    required String title,
    required Future<List<Map<String, dynamic>>> futureData,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar datos',
                  style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No hay datos disponibles',
                  style: TextStyle(color: Colors.white)));
        }

        final data = snapshot.data!;
        return Container(
          color: Colors.black.withOpacity(
              0.5), // Fondo oscuro que coincide con el fondo de la página
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              DataTable(
                columnSpacing: 16.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Fondo oscuro
                  border: Border.all(color: Colors.black),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Cantidad',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Fecha',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: data.map((entry) {
                  final fecha = DateTime.parse(entry['created_at']);
                  return DataRow(
                    color: MaterialStateProperty.all(Colors.black
                        .withOpacity(0.5)), // Fondo oscuro para las filas
                    cells: [
                      DataCell(Text(entry['cantidad'].toString(),
                          style: TextStyle(color: Colors.white))),
                      DataCell(Text(_formatDateTime(fecha),
                          style: TextStyle(color: Colors.white))),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
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
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }
}
