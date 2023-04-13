import 'package:flutter_auth/modelos/Barbero.dart';
import 'package:flutter_auth/modelos/Cita.dart';
import 'package:flutter_auth/modelos/Servicio.dart';
import 'package:flutter_auth/modelos/barberia.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'dart:convert' as convert;

class ConsultasHTTP {
  Future<List<Barberia>> listarBarberiasMejorPuntuadas() async {
    dynamic responseHttp;
    List<Barberia> barberias = [];
    final link = Uri.parse(BaseUrl + "api/listar_barberias_MP.php");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      final length = json.length;
      if (length > 0) {
        responseHttp = json["Barberias"];
        for (var item in responseHttp) {
          Barberia barberia = new Barberia(
              item["id"],
              item["nombre"],
              item["direccion"],
              item["ciudad"],
              item["logo"],
              item["horario"],
              item["telefono"],
              item["calificacion"],
              double.parse(item["Lat"]),
              double.parse(item["Lng"]));
          barberias.add(barberia);
        }
      }
    }
    return barberias;
  }

  Future<List<Barberia>> listarBarberias() async {
    dynamic responseHttp;
    List<Barberia> barberias = [];
    final link = Uri.parse(BaseUrl + "api/listar_barberias.php");
    final response = await http.get(link);

    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      responseHttp = json["Barberias"];

      for (var item in responseHttp) {
        Barberia barberia = new Barberia(
            item["id"],
            item["nombre"],
            item["direccion"],
            item["ciudad"],
            item["logo"],
            item["horario"],
            item["telefono"],
            item["calificacion"],
            double.parse(item["Lat"]),
            double.parse(item["Lng"]));
        barberias.add(barberia);
      }
    }
    return barberias;
  }

  Future<List<Barbero>> listarBarberos(String id) async {
    dynamic responseHttp;
    List<Barbero> barberos = [];
    final link =
        Uri.parse(BaseUrl + "api/listar_barberos.php?id_barberia=" + id);
    final response = await http.get(link);

    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);

      if (json.length > 0) {
        responseHttp = json["Barberos"];
        for (var item in responseHttp) {
          Barbero barbero = new Barbero(
              item["id"],
              item["id_barberia"],
              item["nombre"],
              item["edad"],
              item["foto_perfil"],
              item["estado"]);
          barberos.add(barbero);
        }
      }
    }
    return barberos;
  }

  Future<List<Servicio>> listarServicios(String id) async {
    dynamic responseHttp;
    List<Servicio> servicios = [];
    final link =
        Uri.parse(BaseUrl + "api/listar_servicios.php?id_barberia=" + id);
    final response = await http.get(link);
    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      if (json.length > 0) {
        responseHttp = json["Servicios"];
        for (var item in responseHttp) {
          Servicio servicio = new Servicio(item["id"], item["nombre"],
              item["precio"], item["tiempo"], item["id_barberia"]);
          servicios.add(servicio);
        }
      }
    }
    return servicios;
  }

  Future<List<CitaModel>> misReservas(String id) async {
    dynamic responseHttp;
    List<CitaModel> citas = [];
    final link = Uri.parse(BaseUrl + "api/mis_citas.php?id_usuario=" + id);
    final response = await http.get(link);
    if (response.statusCode != 200) {
      responseHttp = 0;
    } else {
      var json = convert.jsonDecode(response.body);
      print(json);
      if (json.length > 0) {
        responseHttp = json["Citas"];
        for (var item in responseHttp) {
          bool value = _validarValue(
              item["fecha_cita"], item["hora_inicio"], item["minuto_inicio"]);
          CitaModel cita = new CitaModel(
              item["id"],
              item["id_barberia"],
              item["hora_inicio"],
              item["minuto_inicio"],
              item["hora_final"],
              item["minuto_final"],
              item["fecha_cita"],
              item["precio"],
              item["servicios"],
              item["nombre"],
              item["direccion"],
              item["nombre_barbero"],
              item["estado_cita"],
              value);
          citas.add(cita);
        }
      }
    }
    return citas;
  }

  _validarValue(String fechacita, String hora, String minuto) {
    DateTime hoy = new DateTime.now();
    String fecha = fechacita;
    var arrayFecha = fecha.split("-");

    if (int.parse(hora) < 10) {
      hora = "0" + hora;
    }

    if (int.parse(minuto) < 10) {
      minuto = "0" + minuto;
    }

    var mes = arrayFecha[1];
    var dia = arrayFecha[0];

    if (int.parse(mes) < 10) {
      mes = "0" + mes;
    }

    if (int.parse(dia) < 10) {
      dia = "0" + dia;
    }

    var fechaCita = DateTime.parse(arrayFecha[2] +
        '-' +
        mes +
        '-' +
        dia +
        ' ' +
        hora +
        ':' +
        minuto +
        ':00');
    var diferencia = fechaCita.difference(hoy).inMinutes;
    bool value = true;
    if (diferencia < 0) {
      value = false;
    }
    return value;
  }
}
