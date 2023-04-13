import 'package:flutter_auth/http/response.dart';
import 'constant.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class Calificacion {
  Dio dio = new Dio();
  Future<ResponseHttp> calificarServicio(
      double calificacion, int idbarberia, int idservicio) async {
    ResponseHttp responseHttp;

    print(idbarberia);
    print(calificacion);

    FormData datos = new FormData.fromMap({
      'id_barberia': idbarberia,
      'calificacion': calificacion,
      'id_servicio': idservicio
    });

    final link = BaseUrl + "api/calificar_servicio.php";
    await dio.post(link, data: datos).then((value) {
      var json = convert.jsonDecode(value.toString());
      responseHttp = ResponseHttp(json["mensaje"], json["success"]);
    }).onError((error, stackTrace) {
      responseHttp = ResponseHttp("no existe esa URL", 0);
    });
    return responseHttp;
  }
}
