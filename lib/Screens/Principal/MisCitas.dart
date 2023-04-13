import 'package:flutter/material.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/Cita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:flutter_auth/http/calificacion.dart';
import 'package:flutter_auth/http/response.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MisCitas extends StatefulWidget {
  _MisCitasState createState() => new _MisCitasState();
}

class _MisCitasState extends State<MisCitas> {
  bool loading = false;
  Calificacion calificarService = new Calificacion();
  ConsultasHTTP consultas = new ConsultasHTTP();
  List<CitaModel> citas = [];
  String id;
  double _ratingStarLong = 0;

  @override
  void initState() {
    super.initState();
    _obtenerLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/myteams.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 120),
            Container(
                height: 545,
                child: loading
                    ? ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: citas.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: citas[index].estadoCita == "1"
                                    ? Color.fromRGBO(216, 172, 124, 0.9)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: citas[index].value
                                        ? Color.fromRGBO(216, 172, 124, 0.9)
                                        : Colors.black,
                                    padding: EdgeInsets.only(
                                        top: 44, bottom: 44, right: 4, left: 6),
                                    child: IconButton(
                                      icon: Icon(
                                        citas[index].value
                                            ? Icons.calendar_today
                                            : Icons.check_box_rounded,
                                        size: 34,
                                        color: citas[index].value
                                            ? Colors.black
                                            : Color.fromRGBO(
                                                216, 172, 124, 0.9),
                                      ),
                                      onPressed:
                                          citas[index].estadoCita != "1" &&
                                                  !citas[index].value
                                              ? () => showRating(
                                                  citas[index].id_barberia,
                                                  citas[index].id)
                                              : () => calificado(),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 6, top: 15, bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "Fecha: " + citas[index].fecha_cita,
                                            style: TextStyle(fontSize: 20)),
                                        SizedBox(height: 5),
                                        Text(
                                            "Hora: " +
                                                citas[index].hora_inicio +
                                                ":" +
                                                citas[index].minuto_inicio +
                                                " - " +
                                                citas[index].hora_final +
                                                ":" +
                                                citas[index].minuto_final +
                                                "\nBarbero: " +
                                                citas[index].nombreBarbero +
                                                "\nBarberia: " +
                                                citas[index].nombreBarberia +
                                                "\n" +
                                                citas[index].direccionBarberia,
                                            style: TextStyle(fontSize: 10))
                                      ],
                                    ),
                                  ),
                                  citas[index].value
                                      ? Container(
                                          child: Column(children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                  Icons.cancel_presentation),
                                              onPressed: () {},
                                            )
                                          ]),
                                        )
                                      : Center()
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Color.fromRGBO(216, 172, 124, 0.7)),
                          backgroundColor: Colors.transparent,
                          strokeWidth: 7,
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  Future<void> _obtenerLista() async {
    List<CitaModel> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    respuesta = await consultas.misReservas(id);
    setState(() {
      citas = [];
      citas.addAll(respuesta);
      print(citas);
      loading = true;
    });
  }

  Widget builRating() => RatingBar(
        maxRating: 5,
        onRatingChanged: (rating) => setState(() => _ratingStarLong = rating),
        filledIcon: Icons.star,
        emptyIcon: Icons.star_border,
        halfFilledIcon: Icons.star_half,
        isHalfAllowed: true,
        filledColor: Colors.amber,
        size: 36,
      );

  void calificado() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Ya usted califico este servicio...'),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));

  void showRating(String idbarberia, String idservicio) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Calificar servicio'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Del 1 al 5 califique el servicio.'),
                  Container(
                    height: 20,
                  ),
                  builRating(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Calificar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  guardarCalificacion(idbarberia, idservicio);
                },
              ),
            ],
          ));

  Future<void> guardarCalificacion(String idbarberia, String idservicio) async {
    showDialog(
        context: context,
        builder: (_) {
          return const Center(
              child: CircularProgressIndicator.adaptive(
            valueColor:
                AlwaysStoppedAnimation(Color.fromRGBO(216, 172, 124, 0.7)),
          ));
        });

    ResponseHttp response = await calificarService.calificarServicio(
        this._ratingStarLong, int.parse(idbarberia), int.parse(idservicio));

    if (response.success == 1) {
      Navigator.of(context).pop();
      Alert(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        context: context,
        type: AlertType.success,
        title: "GRACIAS...",
        desc: response.mensaje,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                loading = false;
                _obtenerLista();
              });
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Navigator.of(context).pop();
      Alert(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        context: context,
        type: AlertType.error,
        title: "OCURRIO UN ERROR...",
        desc: response.mensaje,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }
}
