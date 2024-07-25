import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetalleCategoria extends StatelessWidget {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchProductosPorCategoria(
      String categoryId) async {
    final response =
        await supabase.from('producto').select('*').eq('categoria', categoryId);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.parameters['categoryId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos por Categoría'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProductosPorCategoria(categoryId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar productos'));
          }
          final productos = snapshot.data!;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return ListTile(
                title: Text(producto['nom_prod']),
                subtitle: Text(producto['descripcion']),
                // Añade más detalles del producto según sea necesario
              );
            },
          );
        },
      ),
    );
  }
}
