import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
// import 'package:inventario/constants/custom_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  final form_key = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final nomprod_Controller = TextEditingController();
  final descripcion_Controller = TextEditingController();
  final precio_Controller = TextEditingController();
  final stock_Controller = TextEditingController();
  final stockminimo_Controller = TextEditingController();
  // final unidadid_Controller = TextEditingController();
  // final categoriaid_Controller = TextEditingController();

  List tiposUnidades = [];
  var idUnidad = null;
  bool guardando = false;

  traerUnidad() async {
    try {
      tiposUnidades = await supabase.from('unidad').select();
      print('----------------------');
      print(tiposUnidades);

      setState(() {});
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Hay un error al traer los datos de unidad',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    print('-----------------');
    traerUnidad();
  }

  List<String> categorias = [
    'Semillas',
    'Fertilizantes',
    'Gramínea',
    'Herbicidas',
    'Insecticidas',
    'Equipos Agrícolas'
  ];

  guardarProducto() async {
    try {
      await supabase.from('producto').insert({
        'nom_prod': nomprod_Controller.text,
        'precio': precio_Controller.text,
        'stock': stock_Controller.text,
        'estatus': 'Activo',
        'stock_minimo': stockminimo_Controller.text,
        'descripcion': descripcion_Controller.text,
      });
      Get.snackbar('Guardado',
          'Producto Guardado'); //para mostrar la notificacion de guardado
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'No se pudo guardar',
          backgroundColor: Colors.blueGrey, colorText: Colors.white);
    } finally {
      setState(() {
        guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
          titulo: 'Formulario de Productos', colorNew: Colors.green),
      /* drawer: Custom_Drawer(usuario: ,), */
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: form_key,
          child: Column(
            children: [
              TextFormField(
                controller: nomprod_Controller,
                decoration: InputDecoration(labelText: 'Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descripcion_Controller,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la descripción del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precio_Controller,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el precio del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stock_Controller,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el stock del producto';
                  }
                  return null;
                },
              ),

              //Input seleccionador
              DropdownButton(
                hint: Text('Selecciona una unidad'),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                menuMaxHeight: 500,
                value: idUnidad,
                items: tiposUnidades
                    .map((e) => DropdownMenuItem(
                          value: e['id'],
                          child: Text(e['Tipo']),
                        ))
                    .toList(),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    idUnidad = value;
                  });
                },
              ),

              //
              TextFormField(
                controller: stockminimo_Controller,
                decoration: InputDecoration(labelText: 'Stock Minimo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el stock minímo del producto';
                  }
                  return null;
                },
              ),
              //  DropdownButtonFormField<String>(
              //   value: selected_Categoria,
              //   decoration: InputDecoration(labelText: 'Categoría'),
              //   items: unidades.map((categoria){
              //     return DropdownMenuItem<String>(
              //       value: categoria['id'].toString(),
              //       child: Text(categoria['nom_cat']),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       selected_Categoria = newValue;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Selecciona una categoría';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardando
                    ? null
                    : () {
                        if (form_key.currentState!.validate()) {
                          print('Guardado');
                          guardarProducto();
                        } else {
                          print('M A L');
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
