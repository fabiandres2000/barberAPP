import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Principal/Carousel.dart';
import 'package:flutter_auth/Screens/Principal/ListView.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/barberia.dart';
import 'ListView.dart';

class Barberias extends StatefulWidget {
  BarberiaslState createState() => new BarberiaslState();
}

class BarberiaslState extends State<Barberias> {
  ConsultasHTTP consultas = ConsultasHTTP();
  List<Barberia> listaBarberiasMejorPuntuadas;
  List<Barberia> listaBarberias;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _cargarBarberias();
  }

  _cargarBarberias() async {
    var request = await consultas.listarBarberiasMejorPuntuadas();
    var request2 = await consultas.listarBarberias();
    setState(() {
      listaBarberiasMejorPuntuadas = request;
      listaBarberias = request2;
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _textHeader(),
                loading
                    ? Carousel(barberias: listaBarberiasMejorPuntuadas)
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Color.fromRGBO(216, 172, 124, 0.7)),
                        backgroundColor: Colors.transparent,
                        strokeWidth: 7,
                      ),
                _textHeader2(),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: loading
                  ? ListView_(barberias: listaBarberias)
                  : Container(
                      width: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Color.fromRGBO(216, 172, 124, 0.7)),
                            backgroundColor: Colors.transparent,
                            strokeWidth: 7,
                          ),
                        ],
                      )))
        ]));
  }

  Widget _textHeader() {
    return Container(
        padding:
            const EdgeInsets.only(top: 20, right: 20, bottom: 10, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Mejor Calificadas ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'quick',
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 10,
                      ),
                    ])),
            Text(
              "(Calificación mayor o igual a 3)",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  Widget _textHeader2() {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Todas las Barberias",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 10,
                    ),
                  ]),
            ),
            Text(
              "(Calificación de 1 a 5)",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
