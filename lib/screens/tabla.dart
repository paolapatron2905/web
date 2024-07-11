import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_drawer.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:inventario/models/usuario.dart'; // Importar la clase Usuario
import 'package:get/get.dart';

class Ejemplo extends StatefulWidget {
  @override
  State<Ejemplo> createState() => _EjemploState();
}

class _EjemploState extends State<Ejemplo> {
  //final usuario = Get.arguments as Usuario;
  final List<Map<String, dynamic>> products = [
    {
      'producto': 'Producto 1',
      'unidad': 'Kg',
      'descripción': 'Descripción del Producto 1',
      'precio': 10.0,
      'stock': 5,
      'stock_minimo': 10,
      'categoria': 'Jardín',
      'proveedor': 'Proveedor A',
      'estado': 'Disponible',
    },
    {
      'producto': 'Producto 2',
      'unidad': 'Lt',
      'descripción': 'Descripción del Producto 2',
      'precio': 20.0,
      'stock': 20,
      'stock_minimo': 10,
      'categoria': 'Cultivo',
      'proveedor': 'Proveedor B',
      'estado': 'Disponible',
    },
    {
      'producto': 'Producto 3',
      'unidad': 'Pc',
      'descripción': 'Descripción del Producto 3',
      'precio': 15.0,
      'stock': 15,
      'stock_minimo': 10,
      'categoria': 'Jardín',
      'proveedor': 'Proveedor C',
      'estado': 'No disponible',
    },
  ];

  String selectedCategory = 'Todas';
  String selectedProvider = 'Todos';
  String selectedState = 'Todos';
  double minPrice = 0;
  double maxPrice = 100;
  double minStock = 0;
  double maxStock = 100;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLowStock();
  }

  void _checkLowStock() {
    List<String> lowStockProducts = products
        .where((product) => product['stock'] < product['stock_minimo'])
        .map<String>((product) => product['producto'] as String)
        .toList();

    if (lowStockProducts.isNotEmpty) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _showLowStockAlert(lowStockProducts);
      });
    }
  }

  void _showLowStockAlert(List<String> lowStockProducts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta de Stock Bajo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: lowStockProducts
                  .map((product) => Text('El stock de $product está bajo.'))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInputDialog(BuildContext context, String action, int index) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action cantidad'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Ingrese la cantidad"),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                final int? amount = int.tryParse(_controller.text);
                if (amount != null && amount > 0) {
                  setState(() {
                    if (action == 'Entrada') {
                      products[index]['stock'] += amount;
                    } else if (action == 'Salida') {
                      if (products[index]['stock'] >= amount) {
                        products[index]['stock'] -= amount;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'La cantidad de salida no debe superar el stock disponible.'),
                          ),
                        );
                      }
                    }
                    if (products[index]['stock'] == 0) {
                      products[index]['estado'] = 'No disponible';
                    } else if (products[index]['stock'] > 0) {
                      products[index]['estado'] = 'Disponible';
                    }
                    _checkLowStock();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ingrese una cantidad válida.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final matchesCategory = selectedCategory == 'Todas' ||
          product['categoria'] == selectedCategory;
      final matchesProvider = selectedProvider == 'Todos' ||
          product['proveedor'] == selectedProvider;
      final matchesState =
          selectedState == 'Todos' || product['estado'] == selectedState;
      final matchesPrice =
          product['precio'] >= minPrice && product['precio'] <= maxPrice;
      final matchesStock =
          product['stock'] >= minStock && product['stock'] <= maxStock;
      final matchesSearch = searchController.text.isEmpty ||
          product['producto']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          product['descripción']
              .toLowerCase()
              .contains(searchController.text.toLowerCase());

      return matchesCategory &&
          matchesProvider &&
          matchesState &&
          matchesPrice &&
          matchesStock &&
          matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Inventario', colorNew: Colors.green),
      //drawer: Custom_Drawer(usuario: usuario),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre o descripción',
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: <String>['Todas', 'Jardín', 'Cultivo']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedProvider,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProvider = newValue!;
                          });
                        },
                        items: <String>[
                          'Todos',
                          'Proveedor A',
                          'Proveedor B',
                          'Proveedor C'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedState,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedState = newValue!;
                          });
                        },
                        items: <String>['Todos', 'Disponible', 'No disponible']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(minPrice, maxPrice),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  labels: RangeLabels(
                    '\$${minPrice.toStringAsFixed(0)}',
                    '\$${maxPrice.toStringAsFixed(0)}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                    });
                  },
                ),
                RangeSlider(
                  values: RangeValues(minStock, maxStock),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  labels: RangeLabels(
                    '${minStock.toStringAsFixed(0)} unidades',
                    '${maxStock.toStringAsFixed(0)} unidades',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      minStock = values.start;
                      maxStock = values.end;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Producto')),
                    DataColumn(label: Text('Descripción')),
                    DataColumn(label: Text('Precio')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Proveedor')),
                    DataColumn(label: Text('Estado')),
                    DataColumn(label: Text('Acción')),
                  ],
                  rows: filteredProducts.map((product) {
                    int index = products.indexOf(product);
                    Color rowColor = product['stock'] < product['stock_minimo']
                        ? Colors.red.withOpacity(0.5)
                        : Colors.transparent;
                    Color textColor = product['estado'] == 'No disponible'
                        ? Colors.red
                        : Colors.black;

                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return rowColor;
                      }),
                      cells: [
                        DataCell(Text(product['producto'])),
                        DataCell(Text(product['descripción'])),
                        DataCell(Text('\$' + product['precio'].toString())),
                        DataCell(Text(product['stock'].toString() +
                            ' ' +
                            product['unidad'])),
                        DataCell(Text(product['proveedor'])),
                        DataCell(Text(
                          product['estado'],
                          style: TextStyle(color: textColor),
                        )),
                        DataCell(
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              _showInputDialog(context, value, index);
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Entrada', 'Salida'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
