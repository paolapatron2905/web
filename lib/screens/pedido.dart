import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario/constants/custom_appbar.dart';

class Pedido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Get.parameters['userId'];
    final productId = Get.parameters['productId'];

    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Nuevo Pedido',
        colorNew: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User ID: $userId'),
            Text('Product ID: $productId'),
            // Aquí puedes agregar más lógica para manejar el pedido usando el productId
          ],
        ),
      ),
    );
  }
}
