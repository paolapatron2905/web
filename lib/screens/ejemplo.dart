import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/appbar.dart';

class Ejemplo extends StatelessWidget {
  const Ejemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(titulo: 'Ejemplo', color: Colors.pink),
      drawer: CustomDrawer(),
      body: Column(
        children: [Text('asddee')],
      ),
    );
  }
}
