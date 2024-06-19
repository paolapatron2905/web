import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Color color;

  const Appbar({
    super.key,
    required this.titulo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      backgroundColor: color,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
