import 'package:flutter/material.dart';

class Custom_Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Color colorNew;
  final Color textColor;
  final String logoPath;

  const Custom_Appbar({
    super.key,
    required this.titulo,
    required this.colorNew,
    this.textColor = Colors.white,
    this.logoPath = '../assets/img/logo.png',
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> notificaciones = [
      // Agrega tus notificaciones aquí
      // {'title': 'Notificación 1', 'description': 'Descripción de la notificación 1'},
      // {'title': 'Notificación 2', 'description': 'Descripción de la notificación 2'},
    ];

    return AppBar(
      title: Row(children: [
        Image.asset(
          logoPath,
          height: 55,
        ),

        // Espaciado entre logo y titulo
        SizedBox(width: 10),

        // Título centralizado y truncado
        Text(
          titulo,
          style: TextStyle(
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ]),
      backgroundColor: colorNew,
      elevation: 30,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.notifications, color: textColor),
          onSelected: (String value) {
            // Maneja la selección si es necesario
          },
          itemBuilder: (BuildContext context) {
            if (notificaciones.isEmpty) {
              return [
                PopupMenuItem<String>(
                  value: 'no_notifications',
                  child: ListTile(
                    leading: Icon(Icons.notifications_off),
                    title: Text('Por el momento no hay notificaciones'),
                  ),
                ),
              ];
            } else {
              return notificaciones.map((notificacion) {
                return PopupMenuItem<String>(
                  value: notificacion['title']!,
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(notificacion['title']!),
                    subtitle: Text(notificacion['description']!),
                  ),
                );
              }).toList();
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
