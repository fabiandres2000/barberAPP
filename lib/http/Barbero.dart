import 'dart:io';
import 'package:flutter_auth/http/response.dart';
import 'constant.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class BarberoHttp {
  Dio dio = new Dio();
  Future<ResponseHttp> RegistrarBarbero(
      File imagen, String nombre, String edad, String idbarberia) async {
    ResponseHttp responseHttp;
    String filename = imagen.path.split('/').last;
    FormData datos = new FormData.fromMap({
      'imagen': await MultipartFile.fromFile(imagen.path, filename: filename),
      'idbarberia': idbarberia,
      'nombre': nombre,
      'edad': edad
    });

    final link = BaseUrl + "api/guardar_barbero.php";

    await dio.post(link, data: datos).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp = ResponseHttp(json["mensaje"], json["success"]);
    }).onError((error, stackTrace) {
      responseHttp = ResponseHttp("no existe esa URL", 0);
    });

    return responseHttp;
  }
}
