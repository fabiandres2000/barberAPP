import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Barberia/components/Services.dart';
import 'package:flutter_auth/Screens/Barberia/components/graficos.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/Servicio.dart';
import 'package:flutter_auth/modelos/seriesScales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../http/graficosPrincipales.dart';
import '../../../modelos/Calificacion.dart';

class Home extends StatefulWidget {
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  bool loading = false;
  ConsultasHTTP consultas = new ConsultasHTTP();
  GraficosPrincipales graficos = new GraficosPrincipales();
  List<Servicio> servicios = [];
  String idBarberia;
  int numeroServicios = 0;
  List<charts.Series<CalificacionBarberia, String>> cal = [];
  List<charts.Series<LinearSales, String>> dineroPorBarbero = [];

  @override
  void initState() {
    super.initState();
    _obtenerListaServicios();
    _obtenerCalificaciones();
    _obtenerDineroPorBarbero();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fondo_3x.jpg'),
                  fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(children: <Widget>[
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context, BouncyPageRoute(widget: Services()));
                        },
                        child: Row(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/images/services.png',
                                    width: 100,
                                    height: 100,
                                  ))
                            ]),
                            SizedBox(width: 40),
                            Column(children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    numeroServicios.toString(),
                                    style: TextStyle(fontSize: 40),
                                  )),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Servicios",
                                    style: TextStyle(fontSize: 20),
                                  ))
                            ])
                          ],
                        ),
                      ),
                    ),
                  ])),
              Graficos(this.cal, this.dineroPorBarbero)
            ],
          ),
        ));
  }

  Future<void> _obtenerListaServicios() async {
    List<Servicio> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBarberia = preferences.getString('id');
    respuesta = await consultas.listarServicios(idBarberia);
    setState(() {
      servicios = [];
      servicios.addAll(respuesta);
      numeroServicios = servicios.length;
    });
  }

  Future<void> _obtenerCalificaciones() async {
    List<charts.Series<CalificacionBarberia, String>> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBarberia = preferences.getString('id');
    respuesta = await graficos.grafico_2(idBarberia);
    setState(() {
      cal = [];
      cal.addAll(respuesta);
    });
  }

  Future<void> _obtenerDineroPorBarbero() async {
    List<charts.Series<LinearSales, String>> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBarberia = preferences.getString('id');
    respuesta = await graficos.grafico_1(idBarberia);
    setState(() {
      dineroPorBarbero = [];
      dineroPorBarbero.addAll(respuesta);
    });
  }
}
