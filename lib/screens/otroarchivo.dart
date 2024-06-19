import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/appbar.dart';

class OtroEjemplo extends StatelessWidget {
  const OtroEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(titulo: 'Ejemplo', color: Colors.yellow),
      drawer: CustomDrawer(),
      body: Column(
        children: [Text('asddee')],
      ),
    );
  }
}
