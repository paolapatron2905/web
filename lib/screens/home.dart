import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
// import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> productosCercanos = [];

  @override
  void initState() {
    super.initState();
    _fetchProductosCercanos();
  }

  Future<void> _fetchProductosCercanos() async {
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

      List<Map<String, dynamic>> productos =
          List<Map<String, dynamic>>.from(response);

      // Filtrar productos con stock menor al stock mínimo
      List<Map<String, dynamic>> productosPorReabastecer = productos
          .where((producto) => producto['stock'] < producto['stock_minimo'])
          .toList();

      setState(() {
        productosCercanos = productosPorReabastecer;
      });

      // Mostrar alerta si hay productos por reabastecer
      if (productosPorReabastecer.isNotEmpty) {
        _mostrarAlertaReabastecimiento(productosPorReabastecer);
      }
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

  void _mostrarAlertaReabastecimiento(List<Map<String, dynamic>> productos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Productos por reabastecer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: productos.map((producto) {
              return Text(
                '${producto['nom_prod']} (Stock: ${producto['stock']}, Mínimo: ${producto['stock_minimo']})',
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final userId = Get.parameters['userId'];

    // Variables de diseño (colores)
    Color color_container = Color.fromARGB(255, 124, 213, 44);
    Color color_effects = Colors.black.withOpacity(0.5);
    Color color_fonts_2 = Colors.white;
    // Color color_button1 = Color.fromARGB(255, 70, 160, 30);
    // Color color_button2 = Color.fromARGB(255, 4, 33, 49);
    Color color_lowStock = Colors.red[300]!;

    // Imágenes y rutas
    final String bg_img = '../assets/img/bg.jpg';

    return Scaffold(
      // Encabezado
      appBar: Custom_Appbar(
        titulo: 'Home',
        colorNew: color_container,
        textColor: color_fonts_2,
      ),

      // Menu lateral
      drawer: Custom_Drawer(),

      // Contenido principal
      body: Stack(
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Productos próximos a terminarse',
                  style: TextStyle(color: color_fonts_2),
                ),

                // Espaciado
                SizedBox(height: 10),

                // Productos cercanos
                if (productosCercanos.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: productosCercanos.length,
                      itemBuilder: (context, index) {
                        final producto = productosCercanos[index];
                        return Card(
                          color: color_lowStock,
                          child: ListTile(
                            title: Text(
                              producto['nom_prod'],
                              style: TextStyle(color: color_fonts_2),
                            ),
                            subtitle: Text(
                              'Stock: ${producto['stock']} ${producto['unidad']['nom_unidad']}',
                              style: TextStyle(color: color_fonts_2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (productosCercanos.isEmpty)
                  Text(
                    'No hay productos cercanos a alcanzar su stock mínimo',
                    style: TextStyle(color: color_fonts_2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
