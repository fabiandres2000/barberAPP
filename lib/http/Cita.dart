import 'package:flutter/material.dart';
import 'package:flutter_auth/http/response.dart';
import 'package:flutter_auth/modelos/Barbero.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class CitaHttp {
  String hora_inicio;
  String minuto_inicio;
  String tiempo;
  String id_barbero;
  String id_barberia;
  String id_usuario;
  String fecha_cita;
  String servicios;
  String precio;

  Dio dio = new Dio();

  Future<ResponseHttp> ReservarCita(DateTime fecha, TimeOfDay hora,
      Barbero barbero, int tiempo, double precio, String servicios) async {
    ResponseHttp responseHttp;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    this.hora_inicio = hora.hour.toString();
    this.minuto_inicio = hora.minute.toString();
    this.tiempo = tiempo.toString();
    this.id_barbero = barbero.id.toString();
    this.id_barberia = barbero.idBarberia.toString();
    this.id_usuario = preferences.getString('id');
    this.fecha_cita = fecha.day.toString() +
        "-" +
        fecha.month.toString() +
        "-" +
        fecha.year.toString();
    this.servicios = servicios;
    this.precio = precio.toString();

    FormData datos = new FormData.fromMap({
      'hora_inicio': this.hora_inicio,
      'minuto_inicio': this.minuto_inicio,
      'tiempo': this.tiempo,
      'id_barbero': this.id_barbero,
      'id_barberia': this.id_barberia,
      'id_usuario': this.id_usuario,
      'fecha_cita': this.fecha_cita,
      'precio': this.precio,
      'servicios': this.servicios
    });

    final link = BaseUrl + "api/reserva_cita.php";
    await dio.post(link, data: datos).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp = ResponseHttp(json["mensaje"], json["success"]);
    }).onError((error, stackTrace) {
      responseHttp = ResponseHttp("no existe esa URL", 0);
    });
    return responseHttp;
  }
}
