import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/constants/custom_appbar.dart'; // Asegúrate de tener esta clase

class EmpresasPage extends StatefulWidget {
  const EmpresasPage({super.key});

  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> empresas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchEmpresas();
  }

  fetchEmpresas() async {
    setState(() {
      cargando = true;
    });

    try {
      final response = await supabase.from('empresa').select();

      Get.snackbar('Error', 'No se pudo cargar la lista de empresas',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    
      setState(() {
        empresas = response;
      });
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al cargar las empresas',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Empresas', colorNew: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navega a la página para agregar una nueva empresa
                Get.toNamed(
                    '/agregar_empresa'); // Asegúrate de que esta ruta esté definida en tu GetX routing
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text('Registrar Nueva Empresa'),
            ),
            SizedBox(height: 20),
            cargando
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: empresas.length,
                      itemBuilder: (context, index) {
                        final empresa = empresas[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title:
                                Text(empresa['nom_empresa'] ?? 'No disponible'),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
