import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertarProveedor extends StatefulWidget {
  const InsertarProveedor({super.key});

  @override
  State<InsertarProveedor> createState() => _InsertarProveedorState();
}

class _InsertarProveedorState extends State<InsertarProveedor> {
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
      appBar: AppBar(
        title: Text('Nuevo Proveedor'),
        backgroundColor: Colors.green,
      ),
      body: cargandoEmpresa || cargandoEstado
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formularioKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                          hintText: 'Ingresa el nombre del proveedor'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Completa este campo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: telefonoController,
                      decoration: InputDecoration(
                          hintText: 'Ingresa el telefono del proveedor'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Completa este campo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: correoController,
                      decoration: InputDecoration(
                          hintText: 'Ingresa el correo del proveedor'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Completa este campo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: direccionController,
                      decoration: InputDecoration(
                          hintText: 'Ingresa la dirección del proveedor'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Completa este campo';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: empresaSeleccionada,
                      decoration:
                          InputDecoration(hintText: 'Selecciona una empresa'),
                      items: Empresa.map((tipo) {
                        return DropdownMenuItem<int>(
                          value: tipo['id'],
                          child: Text(tipo['nom_empresa']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          empresaSeleccionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona una empresa';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: estadoSeleccionado,
                      decoration:
                          InputDecoration(hintText: 'Selecciona un estado'),
                      items: Estado.map((estado) {
                        return DropdownMenuItem<int>(
                          value: estado['id'],
                          child: Text(estado['nom_estado']),
                        );
                      }).toList(),
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
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un estado';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: ciudadSeleccionada,
                      decoration:
                          InputDecoration(hintText: 'Selecciona una ciudad'),
                      items: Ciudad.map((ciudad) {
                        return DropdownMenuItem<int>(
                          value: ciudad['id'],
                          child: Text(ciudad['nom_ciudad']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          ciudadSeleccionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona una ciudad';
                        }
                        return null;
                      },
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
                      child: Text(guardando ? 'Guardando' : 'Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
