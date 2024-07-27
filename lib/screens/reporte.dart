import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
=======
>>>>>>> a4de82460562f87c2b81585465e2190f7b503d06

class Reporte extends StatefulWidget {
  const Reporte({super.key});

  @override
  State<Reporte> createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> productoEntradas = [];
  List<Map<String, dynamic>> productoSalidas = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchProductos();
    await _fetchProductoEntradas();
    await _fetchProductoSalidas();
  }

  Future<void> _fetchProductos() async {
    try {
      final List<dynamic> response =
          await supabase.from('producto').select('*');
      setState(() {
        productos = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error al obtener productos: $e');
    }
  }

  Future<void> _fetchProductoEntradas() async {
    try {
      final List<dynamic> response =
          await supabase.from('producto_entrada').select('*');
      List<Map<String, dynamic>> groupedData = _groupByDate(response);
      setState(() {
        productoEntradas = groupedData;
      });
    } catch (e) {
      print('Error al obtener producto_entrada: $e');
    }
  }

  Future<void> _fetchProductoSalidas() async {
    try {
      final List<dynamic> response =
          await supabase.from('producto_saliente').select('*');
      List<Map<String, dynamic>> groupedData = _groupByDate(response);
      setState(() {
        productoSalidas = groupedData;
      });
    } catch (e) {
      print('Error al obtener producto_saliente: $e');
    }
  }

  List<Map<String, dynamic>> _groupByDate(List<dynamic> data) {
    Map<String, double> groupedMap = {};

    for (var item in data) {
      String date = item['created_at'].split(' ')[0]; // Extraer solo la fecha
      double cantidad = item['cantidad'].toDouble();

      if (groupedMap.containsKey(date)) {
        groupedMap[date] = groupedMap[date]! + cantidad;
      } else {
        groupedMap[date] = cantidad;
      }
    }

    List<Map<String, dynamic>> groupedData = groupedMap.entries.map((entry) {
      return {'fecha': entry.key, 'cantidad': entry.value};
    }).toList();

    // Ordenar por fecha
    groupedData.sort((a, b) => a['fecha'].compareTo(b['fecha']));

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Reportes', colorNew: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProductoChart(),
            _buildProductoEntradaChart(),
            _buildProductoSalidaChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Stock de Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: 300,
              child: BarChart(_getBarChartData(productos, 'stock'))),
        ],
      ),
    );
  }

  Widget _buildProductoEntradaChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Entradas de Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: 300,
              child: productoEntradas.isEmpty
                  ? Center(child: Text('No hay datos disponibles'))
                  : LineChart(_getLineChartData(productoEntradas, 'cantidad'))),
        ],
      ),
    );
  }

  Widget _buildProductoSalidaChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Salidas de Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: 300,
              child: productoSalidas.isEmpty
                  ? Center(child: Text('No hay datos disponibles'))
                  : LineChart(_getLineChartData(productoSalidas, 'cantidad'))),
        ],
      ),
    );
  }

  BarChartData _getBarChartData(List<Map<String, dynamic>> data, String field) {
    return BarChartData(
      barGroups: data.map((item) {
        return BarChartGroupData(
          x: data.indexOf(item),
          barRods: [
            BarChartRodData(y: item[field].toDouble(), colors: [Colors.blue])
          ],
        );
      }).toList(),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          interval: 30,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) {
            int index = value.toInt();
            if (index < data.length) {
              return data[index]['nom_prod'];
            }
            return '';
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 30,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          top: BorderSide.none,
          right: BorderSide.none,
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  LineChartData _getLineChartData(
      List<Map<String, dynamic>> data, String field) {
    return LineChartData(
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          interval: 30,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) {
            int index = value.toInt();
            if (index < data.length) {
              String fecha = data[index]['fecha'];
              return DateFormat('dd-MM').format(DateTime.parse(fecha));
            }
            return '';
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 30,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          top: BorderSide.none,
          right: BorderSide.none,
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            return FlSpot(index.toDouble(), item[field].toDouble());
          }).toList(),
          isCurved: true,
          colors: [Colors.green],
          barWidth: 4,
          belowBarData: BarAreaData(
            show: true,
            colors: [Colors.green.withOpacity(0.3)],
          ),
        ),
      ],
    );
  }
}
