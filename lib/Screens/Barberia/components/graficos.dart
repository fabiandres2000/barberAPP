import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Graficos extends StatelessWidget {
  final List<charts.Series> seriesList;
  final List<charts.Series> porBarbero;
  final bool animate = false;

  Graficos(this.seriesList, this.porBarbero);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(children: [
          Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                              "Opiniones de los usuarios (por categoria)",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 200,
                          child: charts.BarChart(
                            seriesList,
                            animate: animate,
                          )),
                    )
                  ]),
                ],
              ),
            ),
          ),
          Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text("Dinero Generado\n(Por barbero)",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 20, left: 20, bottom: 20),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 200,
                          child: charts.BarChart(
                            porBarbero,
                            animate: animate,
                          )),
                    )
                  ]),
                ],
              ),
            ),
          )
        ]));
  }
}
