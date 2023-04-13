import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Principal/Cita.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:flutter_auth/modelos/barberia.dart';

class ListView_ extends StatelessWidget {
  final List<Barberia> barberias;
  ListView_({Key key, @required this.barberias}) : super(key: key);
  Color color = Colors.white;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: _listaCard(context),
      ),
    );
  }

  List<Widget> _listaCard(BuildContext context) {
    List<Widget> widgets = [];
    if (barberias != null) {
      for (var item in barberias) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(context, BouncyPageRoute(widget: Cita(item)));
              },
              child: Container(
                decoration: _boxDecoration(),
                height: 120,
                child: Row(children: <Widget>[
                  _logo(item.logo),
                  _infoBarb(item.nombre, item.direccion, item.calificacion,
                      item.ciudad),
                ]),
              ),
            )));
        widgets.add(
          SizedBox(height: size.height * 0.02),
        );
      }
    }
    return widgets;
  }

  _boxDecoration() {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black38, offset: Offset(2, 2), blurRadius: 8)
        ]);
  }

  _logo(String urlLogo) {
    String url = BaseUrl + "logos/" + urlLogo;
    return Padding(
        padding: EdgeInsets.only(left: 10),
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              url,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  _infoBarb(
      String nombre, String direccion, String numeroEstrellas, String ciudad) {
    return Padding(
        padding: EdgeInsets.only(left: 10, top: 15),
        child: Container(
            width: 250,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  nombre + ' ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: size.height * 0.007),
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.location_on, size: 14),
                      ),
                      WidgetSpan(
                        child: Text(
                          direccion,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.location_city, size: 14),
                      ),
                      WidgetSpan(
                        child: Text(
                          ciudad,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _estrellas(numeroEstrellas),
              ],
            )));
  }

  _estrellas(String calificacion) {
    int numeroEstrellas = double.parse(calificacion).round();
    return Padding(
        padding: EdgeInsets.only(left: 0, right: 40),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.015),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _definirEstrellas(numeroEstrellas))
            ],
          ),
        ));
  }

  List<Widget> _definirEstrellas(int numeroEstrellas) {
    List<Widget> estrellas = [];
    for (var i = 1; i <= 5; i++) {
      if (i <= numeroEstrellas) {
        estrellas.add(
          Icon(
            Icons.star,
            size: 30,
            color: Color.fromRGBO(197, 157, 95, 1),
          ),
        );
      } else {
        estrellas.add(Icon(
          Icons.star_border,
          size: 30,
          color: Color.fromRGBO(197, 157, 95, 1),
        ));
      }
    }
    return estrellas;
  }
}
