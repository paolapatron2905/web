import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/constants/custom_appbar.dart';

class DetalleCategoria extends StatefulWidget {
  @override
  _DetalleCategoriaState createState() => _DetalleCategoriaState();
}

class _DetalleCategoriaState extends State<DetalleCategoria> {
  final supabase = Supabase.instance.client;
  String searchQuery = '';

  Future<List<Map<String, dynamic>>> _fetchProductosPorCategoria(
      String categoryId) async {
    final response = await supabase.from('producto').select('''
          id,
          nom_prod,
          descripcion,
          precio,
          stock,
          stock_minimo,
          unidad (nom_unidad),
          categoria (nom_cat),
          estatus
        ''').eq('categoria_id', categoryId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<String> _fetchCategoriaNombre(String categoryId) async {
    final response = await supabase
        .from('categoria')
        .select('nom_cat')
        .eq('id', categoryId)
        .single();

    return response['nom_cat'];
  }

  double _calculateTotal(List<Map<String, dynamic>> productos) {
    double total = 0;
    for (var producto in productos) {
      total += producto['stock'] * producto['precio'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.parameters['categoryId'];

    // Variables de diseño (colores)
    Color colorContainer = Color.fromARGB(255, 124, 213, 44);
    Color colorEffects = Colors.black.withOpacity(0.5);
    Color colorFonts2 = Colors.white;
    Color colorButton2 = Color.fromARGB(255, 4, 33, 49);

    // Imágenes y rutas
    final String bgImg = 'assets/img/bg.jpg';

    return FutureBuilder<String>(
      future: _fetchCategoriaNombre(categoryId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: Custom_Appbar(
              titulo: 'Cargando...',
              colorNew: colorContainer,
              textColor: colorFonts2,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: Custom_Appbar(
              titulo: 'Error',
              colorNew: colorContainer,
              textColor: colorFonts2,
            ),
            body: Center(
                child: Text('Error al cargar categoría',
                    style: TextStyle(color: colorFonts2))),
          );
        }
        final categoriaNombre = snapshot.data!;

        return Scaffold(
          appBar: Custom_Appbar(
            titulo: categoriaNombre,
            colorNew: colorContainer,
            textColor: colorFonts2,
          ),
          body: Stack(
            children: [
              // Fondo 1
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bgImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Fondo 2
              Container(
                color: colorEffects,
              ),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchProductosPorCategoria(categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar productos',
                          style: TextStyle(color: colorFonts2)),
                    );
                  }
                  final productos = snapshot.data!;
                  final totalInventario = _calculateTotal(productos);

                  // Filtrar productos basado en la búsqueda
                  final filteredProductos = productos
                      .where((producto) => producto['nom_prod']
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Productos en esta Categoría',
                                      style: TextStyle(
                                        color: colorFonts2,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: filteredProductos.length,
                                        itemBuilder: (context, index) {
                                          final producto =
                                              filteredProductos[index];
                                          return Card(
                                            color: colorContainer,
                                            child: ListTile(
                                              title: Text(
                                                producto['nom_prod'],
                                                style: TextStyle(
                                                    color: colorFonts2),
                                              ),
                                              subtitle: Text(
                                                'Stock: ${producto['stock']} ${producto['unidad']['nom_unidad']}',
                                                style: TextStyle(
                                                    color: colorFonts2),
                                              ),
                                              trailing: ElevatedButton(
                                                onPressed: () {
                                                  Get.toNamed(
                                                      '/productoDetalle?id=${producto['id']}');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colorButton2,
                                                ),
                                                child: Text(
                                                  'Detalles',
                                                  style: TextStyle(
                                                    color: colorFonts2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              padding: EdgeInsets.all(16),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Valuación de categoria',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        '\$${totalInventario.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Productos en esta Categoría',
                                style: TextStyle(
                                  color: colorFonts2,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredProductos.length,
                                  itemBuilder: (context, index) {
                                    final producto = filteredProductos[index];
                                    return Card(
                                      color: colorContainer,
                                      child: ListTile(
                                        title: Text(
                                          producto['nom_prod'],
                                          style: TextStyle(color: colorFonts2),
                                        ),
                                        subtitle: Text(
                                          'Stock: ${producto['stock']} ${producto['unidad']['nom_unidad']}',
                                          style: TextStyle(color: colorFonts2),
                                        ),
                                        trailing: ElevatedButton(
                                          onPressed: () {
                                            Get.toNamed(
                                                '/productoDetalle?id=${producto['id']}');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorButton2,
                                          ),
                                          child: Text(
                                            'Detalles',
                                            style: TextStyle(
                                              color: colorFonts2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Valuación de categoria',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        '\$${totalInventario.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
