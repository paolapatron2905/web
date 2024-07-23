import 'package:flutter/material.dart';

class Custom_Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Color colorNew;
  final textColor;

  const Custom_Appbar({
    super.key,
    required this.titulo,
    required this.colorNew,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: TextStyle(
          color: textColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: colorNew,
      elevation: 30,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
