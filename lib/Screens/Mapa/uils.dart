import 'package:geolocator/geolocator.dart';
import '../../modelos/barberia.dart';
import 'dart:math' as Math;

class Utils {
  Future<List<Barberia>> listarBarberiasFiltradas(
      List<Barberia> barberias, double distancia) async {
    List<Barberia> barberiasFiltradas = [];
    Position posicion = await this.determinePosition();
    for (var item in barberias) {
      var dist = calcularDistancia(posicion, item.lat, item.long);
      if (dist <= distancia) {
        item.distancia = dist.toStringAsFixed(3);
        barberiasFiltradas.add(item);
      }
    }

    return barberiasFiltradas;
  }

  Future<Position> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  calcularDistancia(Position posicion, double lat, double long) {
    var degtorad = 0.01745329;
    var radtodeg = 57.29577951;
    var lat1h = posicion.latitude.toString();
    var lat2h = lat.toString();
    var long1h = posicion.longitude.toString();
    var long2h = long.toString();
    var lat1 = double.parse(lat1h);
    var lat2 = double.parse(lat2h);
    var long1 = double.parse(long1h);
    var long2 = double.parse(long2h);
    if ((lat1h.lastIndexOf("S")) != -1 || (lat1h.lastIndexOf("s")) != -1)
      lat1 = (lat1 * (-1));
    if ((lat1h.lastIndexOf("W")) != -1 || (lat1h.lastIndexOf("w")) != -1)
      lat1 = (lat1 * (-1));
    if ((lat2h.lastIndexOf("S")) != -1 || (lat2h.lastIndexOf("s")) != -1)
      lat2 = (lat2 * (-1));
    if ((lat2h.lastIndexOf("W") != -1) || (lat2h.lastIndexOf("w")) != -1)
      lat2 = (lat2 * (-1));
    if ((long1h.lastIndexOf("S") != -1) || (long1h.lastIndexOf("s")) != -1)
      long1 = (long1 * (-1));
    if ((long1h.lastIndexOf("W") != -1) || (long1h.lastIndexOf("w")) != -1)
      long1 = (long1 * (-1));
    if ((long2h.lastIndexOf("S") != -1) || (long2h.lastIndexOf("s")) != -1)
      long2 = (long2 * (-1));
    if ((long2h.lastIndexOf("W") != -1) || (long2h.lastIndexOf("w")) != -1)
      long2 = (long2 * (-1));
    var dlong = (long1 - long2);
    var dvalue = (Math.sin(lat1 * degtorad) * Math.sin(lat2 * degtorad)) +
        (Math.cos(lat1 * degtorad) *
            Math.cos(lat2 * degtorad) *
            Math.cos(dlong * degtorad));
    var dd = Math.acos(dvalue) * radtodeg;

    var km = (dd * 111.302);
    km = (km * 100) / 100;
    return km;
  }
}
