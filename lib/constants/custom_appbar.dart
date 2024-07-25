import 'package:flutter/material.dart';

class Custom_Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Color colorNew;
  final Color textColor;

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
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.notifications, color: textColor),
          onSelected: (String value) {
            // Maneja la selección si es necesario
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'notification1',
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificación 1'),
                  subtitle: Text('Descripción de la notificación 1'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'notification2',
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificación 2'),
                  subtitle: Text('Descripción de la notificación 2'),
                ),
              ),
              // Agrega más notificaciones aquí
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
