import 'package:flutter_auth/http/response.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'dart:convert' as convert;

class Usuario {
  String usuario;
  String password;
  String ciudad;
  String tipo = "usuario";
  Usuario(this.usuario, this.ciudad, this.password);

  Future<ResponseHttp> RegistrarUsuario() async {
    ResponseHttp responseHttp;
    final link = Uri.parse(BaseUrl + "api/guardar_usuario.php");
    final response = await http.post(link, body: {
      "usuario": usuario,
      "password": password,
      "ciudad": ciudad,
      "tipo": tipo
    });

    if (response.statusCode != 200) {
      responseHttp = ResponseHttp("no existe esa URL", 0);
    } else {
      var json = convert.jsonDecode(response.body);
      responseHttp = ResponseHttp(json["mensaje"], json["success"]);
    }
    return responseHttp;
  }
}
