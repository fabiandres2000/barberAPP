import 'dart:io';
import 'package:flutter_auth/http/response.dart';
import 'constant.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class ServicioHttp {
  Dio dio = new Dio();

  Future<ResponseHttp> RegistrarServicio(
      String nombre, String precio, String duracion, String idBarberia) async {
    ResponseHttp responseHttp;
    FormData datos = new FormData.fromMap({
      'nombre': nombre,
      'precio': precio,
      'tiempo': duracion,
      'idBarberia': idBarberia
    });
    final link = BaseUrl + "api/guardar_servicio.php";
    await dio.post(link, data: datos).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp = ResponseHttp(json["mensaje"], json["success"]);
    }).onError((error, stackTrace) {
      responseHttp = ResponseHttp("no existe esa URL", 0);
    });
    return responseHttp;
  }
}
