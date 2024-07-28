import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Ejemplo extends StatefulWidget {
  @override
  State<Ejemplo> createState() => _EjemploState();
}

class _EjemploState extends State<Ejemplo> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> productosFiltrados = [];

  // Variables de diseño (colores)
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  // Color color_appbar = Color.fromARGB(255, 44, 111, 127);
  // Color color_bgInputs = Colors.white;
  Color color_effects = Colors.black.withOpacity(0.5);
  // Color color_fonts_1 = Colors.black;
  Color color_fonts_2 = Colors.white;
  Color color_button1 = Color.fromARGB(255, 70, 160, 30);
  Color color_button2 = Color.fromARGB(255, 4, 33, 49);

  // Imágenes y rutas
  final String bg_img = '../assets/img/bg.jpg';
  final String bg_img2 = '../assets/img/bg_registrer.jpg';

  double precioMin = 0;
  double precioMax = 1000;
  double precioActualMin = 0;
  double precioActualMax = 1000;
  double stockMin = 0;
  double stockMax = 1000;
  double stockActualMin = 0;
  double stockActualMax = 1000;
  String categoriaSeleccionada = 'Todas';
  String estatusSeleccionado = 'Todas';
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    _fetchProductos();
    _fetchCategorias();
  }

  Future<void> _fetchProductos() async {
    try {
      final List<dynamic> response = await supabase.from('producto').select('''
            id,
            nom_prod,
            descripcion,
            precio,
            stock,
            stock_minimo,
            unidad (nom_unidad),
            categoria (nom_cat),
            estatus
          ''');

      setState(() {
        productos = List<Map<String, dynamic>>.from(response);
        productosFiltrados = productos;
        precioMin = productos
            .map((p) => p['precio'] as double)
            .reduce((a, b) => a < b ? a : b);
        precioMax = productos
            .map((p) => p['precio'] as double)
            .reduce((a, b) => a > b ? a : b);
        precioActualMin = precioMin;
        precioActualMax = precioMax;
        stockMin = productos
            .map((p) => p['stock'] as double)
            .reduce((a, b) => a < b ? a : b);
        stockMax = productos
            .map((p) => p['stock'] as double)
            .reduce((a, b) => a > b ? a : b);
        stockActualMin = stockMin;
        stockActualMax = stockMax;
      });
    } catch (e) {
      // Manejar error
      print('Error al obtener productos: $e');
    }
  }

  Future<void> _fetchCategorias() async {
    try {
      final List<dynamic> response =
          await supabase.from('categoria').select('id, nom_cat');

      setState(() {
        categorias = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error al obtener categorías: $e');
    }
  }

  void _filtrarProductos() {
    setState(() {
      productosFiltrados = productos.where((producto) {
        final bool coincideBusqueda = producto['nom_prod']
                .toLowerCase()
                .contains(busqueda.toLowerCase()) ||
            producto['descripcion']
                .toLowerCase()
                .contains(busqueda.toLowerCase());
        final bool coincidePrecio = producto['precio'] >= precioActualMin &&
            producto['precio'] <= precioActualMax;
        final bool coincideStock = producto['stock'] >= stockActualMin &&
            producto['stock'] <= stockActualMax;
        final bool coincideCategoria = categoriaSeleccionada == 'Todas' ||
            producto['categoria']['nom_cat'] == categoriaSeleccionada;
        final bool coincideEstatus = estatusSeleccionado == 'Todas' ||
            producto['estatus'] == estatusSeleccionado;

        return coincideBusqueda &&
            coincidePrecio &&
            coincideStock &&
            coincideCategoria &&
            coincideEstatus;
      }).toList();
    });
  }

  Future<void> _actualizarStock(int productoId, double cantidad, bool esEntrada,
      [String motivo = '']) async {
    final producto = productos.firstWhere((p) => p['id'] == productoId);
    double stockActual = producto['stock'];
    double nuevoStock =
        esEntrada ? stockActual + cantidad : stockActual - cantidad;

    if (nuevoStock < 0) {
      Get.snackbar(
          'Error', 'La cantidad de salida no puede superar el stock actual');
      return;
    }

    String tabla = esEntrada ? 'producto_entrada' : 'producto_saliente';

    try {
      // Actualizar el stock y el estatus en la tabla de productos
      await supabase.from('producto').update({
        'stock': nuevoStock,
        'estatus': nuevoStock == 0
            ? 'No disponible'
            : nuevoStock > 0 && producto['estatus'] == 'No disponible'
                ? 'Disponible'
                : producto['estatus'],
      }).eq('id', productoId);

      // Registrar la entrada o salida en la tabla correspondiente
      await supabase.from(tabla).insert({
        'producto_id': productoId,
        'cantidad': cantidad,
        if (!esEntrada) 'motivo': motivo,
      });

      // Refrescar la lista de productos
      setState(() {
        producto['stock'] = nuevoStock;
        producto['estatus'] = nuevoStock == 0
            ? 'No disponible'
            : nuevoStock > 0 && producto['estatus'] == 'No disponible'
                ? 'Disponible'
                : producto['estatus'];
      });

      Get.snackbar('Éxito', 'El stock ha sido actualizado correctamente');
    } catch (e) {
      print('Error al actualizar el stock: $e');
      Get.snackbar('Error', 'Hubo un problema al actualizar el stock');
    }
  }

  void _mostrarModal(BuildContext context, int productoId, bool esEntrada) {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController otroMotivoController = TextEditingController();
    String? motivoSeleccionado;
    final producto = productos.firstWhere((p) => p['id'] == productoId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                  esEntrada ? 'Entrada de producto' : 'Salida de producto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: cantidadController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: esEntrada
                          ? 'Ingrese la cantidad de entrada'
                          : 'Ingrese la cantidad de salida',
                    ),
                  ),
                  if (!esEntrada) ...[
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: motivoSeleccionado,
                      items: ['motivo 1', 'motivo 2', 'motivo 3', 'otro']
                          .map((motivo) => DropdownMenuItem(
                                value: motivo,
                                child: Text(motivo),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          motivoSeleccionado = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Motivo',
                      ),
                    ),
                    if (motivoSeleccionado == 'otro')
                      TextField(
                        controller: otroMotivoController,
                        decoration: InputDecoration(
                          hintText: 'Especifique otro motivo',
                        ),
                      ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    double cantidad =
                        double.tryParse(cantidadController.text) ?? 0;
                    if (cantidad <= 0) {
                      Get.snackbar('Error', 'Ingrese una cantidad válida');
                    } else {
                      String motivo = motivoSeleccionado == 'otro'
                          ? otroMotivoController.text
                          : motivoSeleccionado ?? '';
                      if (!esEntrada && motivo.isEmpty) {
                        Get.snackbar(
                            'Error', 'Debe ingresar un motivo para la salida');
                      } else {
                        if (!esEntrada &&
                            producto['estatus'] == 'No disponible') {
                          Get.snackbar('Error',
                              'No se pueden registrar salidas para un producto No disponible');
                        } else {
                          _actualizarStock(
                              productoId, cantidad, esEntrada, motivo);
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: Custom_Appbar(titulo: 'Inventario', colorNew: color_container),

      // Cuerpo de la pagina
      body: productos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Fondo 1
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(bg_img2),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Fondo 2
                Container(
                  color: color_effects,
                ),

                Column(
                  children: [
                    // Filtro por nombre o descripcion
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Buscar por nombre o descripción',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: color_fonts_2,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: color_fonts_2,
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              busqueda = value;
                              _filtrarProductos();
                            },
                          );
                        },
                      ),
                    ),

                    // Contenedor de Inputs 1
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // Filtro de Precio
                                Row(
                                  children: [
                                    Text(
                                      'Precio: \$${precioActualMin.round()} - \$${precioActualMax.round()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: color_fonts_2,
                                      ),
                                    ),

                                    // Slider ajustable
                                    Expanded(
                                      child: RangeSlider(
                                        values: RangeValues(
                                          precioActualMin,
                                          precioActualMax,
                                        ),
                                        min: precioMin,
                                        max: precioMax,
                                        onChanged: (RangeValues values) {
                                          setState(
                                            () {
                                              precioActualMin = values.start;
                                              precioActualMax = values.end;
                                              _filtrarProductos();
                                            },
                                          );
                                        },
                                        divisions: 10,
                                      ),
                                    ),
                                  ],
                                ),

                                // Filtro de Stock
                                Row(
                                  children: [
                                    Text(
                                      'Stock: ${stockActualMin.round()} - ${stockActualMax.round()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: color_fonts_2,
                                      ),
                                    ),
                                    Expanded(
                                      child: RangeSlider(
                                        values: RangeValues(
                                            stockActualMin, stockActualMax),
                                        min: stockMin,
                                        max: stockMax,
                                        onChanged: (RangeValues values) {
                                          setState(() {
                                            stockActualMin = values.start;
                                            stockActualMax = values.end;
                                            _filtrarProductos();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Contenedor de Inputs 2
                    Row(
                      children: [
                        // Input Seleccionador 1 (Categoria)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              value: categoriaSeleccionada,
                              items: [
                                'Todas',
                                ...categorias.map((c) => c['nom_cat'] as String)
                              ].map((categoria) {
                                return DropdownMenuItem<String>(
                                  value: categoria,
                                  child: Text(categoria),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoriaSeleccionada = newValue!;
                                  _filtrarProductos();
                                });
                              },
                              hint: Text('Seleccionar categoría'),
                            ),
                          ),
                        ),

                        // Input Seleccionador 2 (Disponibilidad)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              value: estatusSeleccionado,
                              items: ['Todas', 'Disponible', 'No disponible']
                                  .map((estatus) {
                                return DropdownMenuItem<String>(
                                  value: estatus,
                                  child: Text(estatus),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  estatusSeleccionado = newValue!;
                                  _filtrarProductos();
                                });
                              },
                              hint: Text('Seleccionar estatus'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tabla de datos
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Descripción')),
                                DataColumn(label: Text('Precio')),
                                DataColumn(label: Text('Stock')),
                                DataColumn(label: Text('Categoría')),
                                DataColumn(label: Text('Estatus')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: productosFiltrados.map((producto) {
                                final bool isStockLow = producto['stock'] <
                                    producto['stock_minimo'];
                                return DataRow(
                                  color: isStockLow
                                      ? MaterialStateProperty.all<Color>(
                                          Colors.red[100]!)
                                      : null,
                                  cells: <DataCell>[
                                    DataCell(
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              '/productoDetalle?id=${producto['id']}');
                                        },
                                        child: Text(producto['nom_prod']),
                                      ),
                                    ),
                                    DataCell(Text(producto['descripcion'])),
                                    DataCell(Text(
                                        '\$' + producto['precio'].toString())),
                                    DataCell(Text(producto['stock'].toString() +
                                        ' ' +
                                        producto['unidad']['nom_unidad'])),
                                    DataCell(
                                        Text(producto['categoria']['nom_cat'])),
                                    DataCell(
                                      Text(
                                        producto['estatus'].toString(),
                                        style: TextStyle(
                                          color: producto['estatus'] ==
                                                  'No disponible'
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      PopupMenuButton<String>(
                                        onSelected: (String result) {
                                          if (result == 'entrada') {
                                            _mostrarModal(
                                                context, producto['id'], true);
                                          } else if (result == 'salida') {
                                            _mostrarModal(
                                                context, producto['id'], false);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'entrada',
                                            child: Text('Entrada'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'salida',
                                            child: Text('Salida'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

      // Boton flotante (registrar producto)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/productos');
        },
        label: Text('Registrar producto'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
