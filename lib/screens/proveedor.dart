import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventario/constants/custom_appbar.dart';

class InsertarProveedor extends StatefulWidget {
  const InsertarProveedor({super.key});

  @override
  State<InsertarProveedor> createState() => _InsertarProveedorState();
}

class _InsertarProveedorState extends State<InsertarProveedor> {
  Color color_container = Color.fromARGB(255, 124, 213, 44);
  Color color_fonts_2 = Colors.white;
  bool guardando = false;
  bool cargandoEmpresa = true;
  bool cargandoCiudad = false;
  bool cargandoEstado = true;

  final supabase = Supabase.instance.client;
  final formularioKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();
  final direccionController = TextEditingController();

  int? empresaSeleccionada;
  int? ciudadSeleccionada;
  int? estadoSeleccionado;
  List<Map<String, dynamic>> Empresa = [];
  List<Map<String, dynamic>> Ciudad = [];
  List<Map<String, dynamic>> Estado = [];

  @override
  void initState() {
    super.initState();
    cargarEmpresa();
    cargarEstados();
  }

  cargarEmpresa() async {
    setState(() {
      cargandoEmpresa = true;
    });
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('empresa').select();
      setState(() {
        Empresa = response;
      });
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al cargar la información de las empresas',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error: $e');
    } finally {
      setState(() {
        cargandoEmpresa = false;
      });
    }
  }

  cargarEstados() async {
    setState(() {
      cargandoEstado = true;
    });
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('estado').select();
      setState(() {
        Estado = response;
      });
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al cargar la información de los estados',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error: $e');
    } finally {
      setState(() {
        cargandoEstado = false;
      });
    }
  }

  cargarCiudad(int estadoId) async {
    setState(() {
      cargandoCiudad = true;
    });
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('ciudad').select().eq('estado_id', estadoId);
      setState(() {
        Ciudad = response;
      });
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al cargar la información de las ciudades',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error: $e');
    } finally {
      setState(() {
        cargandoCiudad = false;
      });
    }
  }

  guardarProveedor() async {
    setState(() {
      guardando = true;
    });

    try {
      final userExists = await supabase
          .from('proveedor')
          .select()
          .eq('nom_proveedor', nombreController.text);

      if (userExists.isNotEmpty) {
        Get.snackbar('Error', 'El proveedor ya existe',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        await supabase.from('proveedor').insert({
          'nom_proveedor': nombreController.text,
          'telefono': telefonoController.text,
          'correo': correoController.text,
          'direccion': direccionController.text,
          'estatus': 'Activo',
          'empresa_id': empresaSeleccionada,
          'ciudad_id': ciudadSeleccionada,
        });

        Get.snackbar('Guardado', 'Proveedor guardado correctamente',
            backgroundColor: Colors.green, colorText: Colors.white);
        limpiarFormulario();
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'Hubo un error al guardar la información del proveedor',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        guardando = false;
      });
    }
  }

  limpiarFormulario() {
    nombreController.clear();
    telefonoController.clear();
    correoController.clear();
    direccionController.clear();
    setState(() {
      empresaSeleccionada = null;
      ciudadSeleccionada = null;
      estadoSeleccionado = null;
      Ciudad = [];
    });
    formularioKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
        titulo: 'Nuevo Proveedor',
        colorNew: color_container,
        textColor: color_fonts_2,
      ),
      body: cargandoEmpresa || cargandoEstado
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formularioKey,
                child: ListView(
                  children: [
                    _buildTextFormField(
                      controller: nombreController,
                      labelText: 'Nombre del Proveedor',
                      hintText: 'Ingresa el nombre del proveedor',
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: telefonoController,
                      labelText: 'Teléfono',
                      hintText: 'Ingresa el teléfono del proveedor',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: correoController,
                      labelText: 'Correo',
                      hintText: 'Ingresa el correo del proveedor',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField(
                      controller: direccionController,
                      labelText: 'Dirección',
                      hintText: 'Ingresa la dirección del proveedor',
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      value: empresaSeleccionada,
                      items: Empresa,
                      hint: 'Selecciona una empresa',
                      onChanged: (value) {
                        setState(() {
                          empresaSeleccionada = value;
                        });
                      },
                      itemLabel: 'nom_empresa',
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      value: estadoSeleccionado,
                      items: Estado,
                      hint: 'Selecciona un estado',
                      onChanged: (value) {
                        setState(() {
                          estadoSeleccionado = value;
                          ciudadSeleccionada = null;
                          Ciudad = [];
                          if (value != null) {
                            cargarCiudad(value);
                          }
                        });
                      },
                      itemLabel: 'nom_estado',
                    ),
                    SizedBox(height: 16),
                    _buildDropdown(
                      value: ciudadSeleccionada,
                      items: Ciudad,
                      hint: 'Selecciona una ciudad',
                      onChanged: (value) {
                        setState(() {
                          ciudadSeleccionada = value;
                        });
                      },
                      itemLabel: 'nom_ciudad',
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: guardando
                          ? null
                          : () {
                              if (formularioKey.currentState!.validate()) {
                                guardarProveedor();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Button color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(guardando ? 'Guardando...' : 'Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Completa este campo';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required int? value,
    required List<Map<String, dynamic>> items,
    required String hint,
    required ValueChanged<int?> onChanged,
    required String itemLabel,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item['id'],
          child: Text(item[itemLabel]),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Selecciona una opción';
        }
        return null;
      },
    );
  }
}
