import 'package:flutter/material.dart';
import 'package:inventario/constants/custom_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

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
      setState(() {
        productoEntradas = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error al obtener producto_entrada: $e');
    }
  }

  Future<void> _fetchProductoSalidas() async {
    try {
      final List<dynamic> response =
          await supabase.from('producto_saliente').select('*');
      setState(() {
        productoSalidas = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error al obtener producto_saliente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(titulo: 'Reportes', colorNew: Colors.green),
      body: SingleChildScrollView(
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Stock de Productos'),
          SizedBox(
              height: 300,
              child: BarChart(_getBarChartData(productos, 'stock'))),
        ],
      ),
    );
  }

  Widget _buildProductoEntradaChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Entradas de Productos'),
          SizedBox(
              height: 300,
              child:
                  LineChart(_getLineChartData(productoEntradas, 'cantidad'))),
        ],
      ),
    );
  }

  Widget _buildProductoSalidaChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Salidas de Productos'),
          SizedBox(
              height: 300,
              child: LineChart(_getLineChartData(productoSalidas, 'cantidad'))),
        ],
      ),
    );
  }

  BarChartData _getBarChartData(List<Map<String, dynamic>> data, String field) {
    return BarChartData(
      barGroups: data.map((item) {
        return BarChartGroupData(
          x: data.indexOf(item), // Use index as x value
          barRods: [
            BarChartRodData(y: item[field].toDouble(), colors: [Colors.blue])
          ],
        );
      }).toList(),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: true),
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
    );
  }

  LineChartData _getLineChartData(
      List<Map<String, dynamic>> data, String field) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: data.map((item) {
            return FlSpot(
                data.indexOf(item).toDouble(), item[field].toDouble());
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
