import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> categorias = [];

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
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

  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'semillas':
        return Icons.eco;
      case 'fertilizantes':
        return Icons.local_florist;
      case 'equipos agrícolas':
        return Icons.build;
      case 'herbicidas':
        return Icons.eco_sharp;
      case 'insecticidas':
        return Icons.bug_report_rounded;
      default:
        return Icons.category;
    }
  }

  void _navigateToRegisterCategory() {
    Get.toNamed('/NuevaCategoria');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Categorias',
        colorNew: Colors.green,
      ),
      body: categorias.isNotEmpty
          ? GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/detalle_categoria/${categoria['id']}');
                  },
                  child: Card(
                    color: Colors.lightGreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForCategory(categoria['nom_cat']),
                          size: 48.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          categoria['nom_cat'],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegisterCategory,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
