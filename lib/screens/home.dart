import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:get/get.dart';
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
      final List<dynamic> response = await supabase
          .from('producto')
          .select('''
            id,
            nom_prod,
            descripcion,
            precio,
            stock,
            stock_minimo,
            unidad (nom_unidad),
            categoria (nom_cat),
            estatus
          ''')
          .eq('estatus', 'Disponible')
          .order('stock', ascending: true)
          .limit(3);

      setState(() {
        productosCercanos = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Get.parameters['userId'];

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
                  'Próximos a terminarse',
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
                          color: color_container,
                          child: ListTile(
                            title: Text(
                              producto['nom_prod'],
                              style: TextStyle(color: color_fonts_2),
                            ),
                            subtitle: Text(
                              'Stock: ${producto['stock']} ${producto['unidad']['nom_unidad']}',
                              style: TextStyle(color: color_fonts_2),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                    '/pedido/$userId/${producto['id']}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color_button2,
                              ),
                              child: Text(
                                'Pedido',
                                style: TextStyle(
                                  color: color_fonts_2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
