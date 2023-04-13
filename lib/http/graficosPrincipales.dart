import 'package:flutter_auth/modelos/seriesScales.dart';
import '../modelos/Calificacion.dart';
import 'constant.dart';
import 'dart:convert' as convert;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class GraficosPrincipales {
  Future<List<charts.Series<LinearSales, String>>> grafico_1(String id) async {
    final link =
        Uri.parse(BaseUrl + "api/dinero_por_barbero.php?id_barberia=" + id);
    dynamic responseHttp;
    List<LinearSales> data = [];

    final response = await http.get(link);
    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      if (json.length > 0) {
        responseHttp = json["DineroGenerado"];
        for (var item in responseHttp) {
          var nombre = item["barbero"].split(" ")[0];
          LinearSales cal =
              new LinearSales(nombre, double.parse(item["cantidad"]));
          data.add(cal);
        }
      }
    }

    return [
      new charts.Series<LinearSales, String>(
        id: 'Global Revenue',
        domainFn: (LinearSales sales, _) => sales.barbero,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Future<List<charts.Series<CalificacionBarberia, String>>> grafico_2(
      String id) async {
    final link = Uri.parse(
        BaseUrl + "api/consultar_calificaciones.php?id_barberia=" + id);
    dynamic responseHttp;
    List<CalificacionBarberia> data = [];

    final response = await http.get(link);
    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      if (json.length > 0) {
        responseHttp = json["Calificaciones"];
        for (var item in responseHttp) {
          CalificacionBarberia cal = new CalificacionBarberia(
              item["detalle"], double.parse(item["cantidad"]));
          data.add(cal);
        }
      }
    }

    return [
      new charts.Series<CalificacionBarberia, String>(
        id: 'Global Revenue',
        domainFn: (CalificacionBarberia calificaciones, _) =>
            calificaciones.detalle,
        measureFn: (CalificacionBarberia calificaciones, _) =>
            calificaciones.calificacion,
        data: data,
      )
    ];
  }
}
