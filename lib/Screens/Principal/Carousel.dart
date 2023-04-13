import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Principal/Cita.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:flutter_auth/modelos/barberia.dart';

class Carousel extends StatelessWidget {
  final List<Barberia> barberias;
  Carousel({Key key, @required this.barberias}) : super(key: key);

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: true,
        reverse: false,
        viewportFraction: 0.86,
        height: 240,
      ),
      items: itemCarousel(context),
    );
  }

  List<Widget> itemCarousel(BuildContext context) {
    List<Widget> widgets = [];
    if (barberias != null) {
      for (var item in barberias) {
        widgets.add(Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 20.0, top: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context, BouncyPageRoute(widget: Cita(item)));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.white54,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 10)
                    ]),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        logo(item.logo),
                        info(item.telefono, item.horario),
                      ],
                    ),
                    nombre(item.nombre, item.direccion),
                    estrellas(item.calificacion)
                  ],
                ),
              ),
            )));
      }
    }
    return widgets;
  }

  logo(String urlogo) {
    String url = BaseUrl + "logos/" + urlogo;
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.network(
          url,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  info(String telefono, String horario) {
    return Container(
        width: 180,
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 18,
              ),
              Expanded(
                  child: Text(
                ' ' + horario,
                style: TextStyle(color: Colors.grey, fontSize: 15),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ))
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Row(children: <Widget>[
            Icon(
              Icons.mobile_friendly,
              color: Colors.grey,
              size: 18,
            ),
            Text(
              ' ' + telefono,
              style: TextStyle(color: Colors.grey, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ])
        ]));
  }

  nombre(String nombre, String direccion) {
    return Center(
        child: Column(children: <Widget>[
      SizedBox(height: size.height * 0.015),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          nombre,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Icon(
          Icons.location_on,
          color: Colors.grey,
          size: 10,
        ),
        Text(
          direccion,
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ]),
    ]));
  }

  estrellas(String calificacion) {
    int numeroEstrellas = double.parse(calificacion).round();
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.015),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _definirEstrellas(numeroEstrellas))
        ],
      ),
    );
  }

  List<Widget> _definirEstrellas(int numeroEstrellas) {
    List<Widget> estrellas = [];
    for (var i = 1; i <= 5; i++) {
      if (i <= numeroEstrellas) {
        estrellas.add(
          Icon(
            Icons.star,
            size: 40,
            color: Color.fromRGBO(197, 157, 95, 1),
          ),
        );
      } else {
        estrellas.add(Icon(
          Icons.star_border,
          size: 40,
          color: Color.fromRGBO(197, 157, 95, 1),
        ));
      }
    }
    return estrellas;
  }
}
