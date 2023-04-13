import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Mapa/mapa.dart';
import 'package:flutter_auth/Screens/Mapa/uils.dart';
import 'package:flutter_auth/Screens/Principal/Cita.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/barberia.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:range_slider_dialog/range_slider_dialog.dart';

class AntesMapa extends StatefulWidget {
  _AntesMapaState createState() => new _AntesMapaState();
}

class _AntesMapaState extends State<AntesMapa> {
  String currentAddress = '';
  String calle = "";
  Position currentposition;
  ConsultasHTTP consultas = ConsultasHTTP();
  Utils utils = Utils();
  List<Barberia> listaBarberias;
  bool loading = false;
  double distanciaBusqueda = 5 / 10;
  RangeValues _rangeValues = RangeValues(0, 1);

  final ButtonStyle style = ElevatedButton.styleFrom(
      shadowColor: Colors.white,
      primary: Color.fromRGBO(216, 172, 124, 1),
      textStyle: const TextStyle(fontSize: 12));

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _cargarBarberias();
  }

  _cargarBarberias() async {
    setState(() {
      loading = false;
    });
    var request = await consultas.listarBarberias();
    var request2 =
        await utils.listarBarberiasFiltradas(request, distanciaBusqueda);
    setState(() {
      listaBarberias = request2;
      listaBarberias.sort((a, b) => a.distancia.compareTo(b.distancia));
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: loading
                ? ListView.builder(
                    itemCount: listaBarberias.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      if (index == 0) {
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(currentAddress),
                            Text("Dirección: $calle"),
                            SizedBox(height: 20),
                            Text("Rango de busqueda: $distanciaBusqueda (KM)"),
                            SizedBox(height: 20),
                            cardTwo(listaBarberias[index]),
                          ],
                        );
                      } else {
                        return cardTwo(listaBarberias[index]);
                      }
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Color.fromRGBO(216, 172, 124, 0.7)),
                      backgroundColor: Colors.transparent,
                      strokeWidth: 7,
                    ),
                  )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(216, 172, 124, 1),
            onPressed: () {
              showRangeSliderDialog(context, this._rangeValues, (e) {
                setState(() {
                  this._rangeValues = e;
                  this.distanciaBusqueda = e.end.roundToDouble();
                  this._cargarBarberias();
                });
              });
            },
            child: const Icon(Icons.add_location_alt_rounded)));
  }

  cardTwo(Barberia barberia) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: ExpansionCard(
            margin: EdgeInsets.only(top: 0),
            title: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(barberia.nombre),
                    subtitle: Text('Distancia: ' +
                        barberia.distancia.toString() +
                        " (KM)"),
                    leading: logo(barberia.logo),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, right: 50, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: style,
                        onPressed: () {
                          Navigator.push(
                              context,
                              BouncyPageRoute(
                                  widget: MapSample(_rangeValues.end * 1000)));
                        },
                        child: const Text('Ver en Mapa'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: style,
                        onPressed: () {
                          Navigator.push(
                              context, BouncyPageRoute(widget: Cita(barberia)));
                        },
                        child: const Text('Apartar Cita'),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void showRangeSliderDialog(BuildContext context, RangeValues defaultValue,
      Function(RangeValues) callback) async {
    await RangeSliderDialog.display(context,
        minValue: 0,
        maxValue: 10,
        acceptButtonText: 'ACEPTAR',
        cancelButtonText: 'CANCELAR',
        headerText: 'Seleccione un rango de busqueda en (Km)',
        selectedRangeValues: defaultValue, onApplyButtonClick: (value) {
      callback(value);
      Navigator.pop(context);
    });
  }

  logo(String urlogo) {
    String url = BaseUrl + "logos/" + urlogo;
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.network(
          url,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        calle = place.street;

        print(currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }
}
