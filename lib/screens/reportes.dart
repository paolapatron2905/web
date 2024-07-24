import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Reportes extends StatefulWidget {
  const Reportes({super.key});

  @override
  State<Reportes> createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  List<Map<String, dynamic>> listaEntrante = [];
  List<Map<String, dynamic>> listaSaliente = [];
  bool cargando = true;
  final supabase = Supabase.instance.client;
  List<OrdinalGroup> ordinalGroup = [];

  traerDatos() async {
    print('--------');
    print('trayendo datos');

    setState(() {
      cargando = true;
    });

    try {
      final responseEntrante = await supabase
          .from('producto_entrante')
          .select()
          .order('created_at', ascending: true)
          .execute();

      final responseSaliente = await supabase
          .from('producto_saliente')
          .select()
          .order('created_at', ascending: true)
          ._execute();

      if (responseEntrante.error == null && responseSaliente.error == null) {
        listaEntrante = List<Map<String, dynamic>>.from(responseEntrante.data);
        listaSaliente = List<Map<String, dynamic>>.from(responseSaliente.data);

        List<OrdinalData> entranteList = listaEntrante.map((item) {
          return OrdinalData(
            domain: item['created_at'],
            measure: item['cantidad'],
          );
        }).toList();

        List<OrdinalData> salienteList = listaSaliente.map((item) {
          return OrdinalData(
            domain: item['created_at'],
            measure: item['cantidad'],
          );
        }).toList();

        ordinalGroup = [
          OrdinalGroup(
            id: 'Entrante',
            data: entranteList,
          ),
          OrdinalGroup(
            id: 'Saliente',
            data: salienteList,
          ),
        ];

        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('----------');
      print('hay un error');
      print(e);
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    traerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grafica de Productos Entrantes y Salientes')),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text('Gráfica'),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBarO(
                    groupList: ordinalGroup,
                  ),
                ),
              ],
            ),
    );
  }
}
