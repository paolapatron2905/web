import 'package:supabase_flutter/supabase_flutter.dart';

class Sesion {
  int? tipo_usuario;

  Future<int?> sesion() async {
    final supabase = Supabase.instance.client;

    await Future.delayed(Duration(seconds: 1));

    final token = supabase.auth.currentUser?.id;

    if (token == null) {
      print('----- no hay sesión -----');
      // cambiar pantalla
      return 0;
    } else {
      // verificar tipo de usuario
      final response = await supabase
          .from('usuario')
          .select('tipo_usuario_id')
          .eq('fk_usuario', token)
          .limit(1)
          .single();

      print('Error al obtener tipo de usuario: ${response}');
      return null;
    
      tipo_usuario = response['tipo_usuario_id'] as int?;
      return tipo_usuario;
    }
  }
}
