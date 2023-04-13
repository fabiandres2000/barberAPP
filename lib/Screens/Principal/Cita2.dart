import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/http/Cita.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:flutter_auth/http/response.dart';
import 'package:flutter_auth/modelos/Barbero.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/Servicio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReservaCita extends StatefulWidget {
  final Barbero barberoSeleccionado;
  ReservaCita(this.barberoSeleccionado);
  ReservaCitaState createState() => new ReservaCitaState(barberoSeleccionado);
}

class ReservaCitaState extends State<ReservaCita> {
  bool loading = false;
  var selectedDate = DateTime.now();
  var selectedTime = TimeOfDay.now();
  ConsultasHTTP consultas = new ConsultasHTTP();
  final Barbero barberoSeleccionado;
  ReservaCitaState(this.barberoSeleccionado);
  Size size;

  List<Servicio> servicios = [];
  String id_barberia;

  double precio = 0.0;
  int tiempo = 10;
  String serviciosSeleccionados;

  CitaHttp http = new CitaHttp();

  @override
  void initState() {
    super.initState();
    _obtenerListaServicios();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: ColorMenu,
        title: Center(child: Text("RESERVA DE CITA")),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.save_sharp),
            onPressed: () {
              _guardarCita(this.context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/myteams.png'),
                fit: BoxFit.cover)),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 140, left: 20, right: 20),
          width: size.width,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(
                  BaseUrl + "fotos_perfil/" + barberoSeleccionado.foto_perfil,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              Text(barberoSeleccionado.nombre,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quick',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                        ),
                      ])),
              Text(barberoSeleccionado.edad + " Años",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quick',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                        ),
                      ])),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.calendar_today_sharp,
                                        size: 20),
                                  ),
                                  WidgetSpan(
                                    child: Text(
                                      "  " +
                                          selectedDate.day.toString() +
                                          "-" +
                                          selectedDate.month.toString() +
                                          "-" +
                                          selectedDate.year.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.watch_later, size: 20),
                                  ),
                                  WidgetSpan(
                                    child: Text(
                                      " " +
                                          selectedTime.hour.toString() +
                                          ":" +
                                          selectedTime.minute.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: 300,
                child: loading
                    ? ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: servicios.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text("Nombre: " + servicios[index].nombre),
                            subtitle: Text("Precio: " +
                                servicios[index].precio +
                                " Pesos. \n" +
                                "Duracion:  " +
                                servicios[index].tiempo +
                                " minutos"),
                            secondary: const Icon(Icons.arrow_right),
                            autofocus: false,
                            activeColor: Color.fromRGBO(216, 172, 124, 1),
                            checkColor: Colors.white,
                            selected: servicios[index].value,
                            value: servicios[index].value,
                            onChanged: (bool value) {
                              setState(() {
                                servicios[index].value = value;
                                _calcularPrecio();
                              });
                            },
                          ));
                        })
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Color.fromRGBO(216, 172, 124, 0.7)),
                          backgroundColor: Colors.transparent,
                          strokeWidth: 7,
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                color: Color.fromRGBO(216, 172, 124, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("TIEMPO: " + tiempo.toString() + " Mts",
                        style: TextStyle(color: Colors.white)),
                    Text("PRECIO: " + precio.toString() + " COP",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year),
      lastDate: DateTime(selectedDate.year + 1),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime)
      setState(() {
        selectedTime = selected;
      });
  }

  Future<void> _obtenerListaServicios() async {
    List<Servicio> respuesta;
    id_barberia = barberoSeleccionado.idBarberia;
    respuesta = await consultas.listarServicios(id_barberia);
    print(respuesta);
    setState(() {
      servicios = [];
      servicios.addAll(respuesta);
      loading = true;
    });
  }

  _calcularPrecio() {
    serviciosSeleccionados = "";
    precio = 0;
    tiempo = 10;
    for (var item in servicios) {
      if (item.value) {
        precio = precio + double.parse(item.precio);
        tiempo = tiempo + int.parse(item.tiempo);
        serviciosSeleccionados = serviciosSeleccionados + item.id + " ";
      }
    }
  }

  Future<void> _guardarCita(BuildContext context) async {
    if (_validarFecha(this.selectedDate, this.selectedTime)) {
      showDialog(
          context: context,
          builder: (_) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
              valueColor:
                  AlwaysStoppedAnimation(Color.fromRGBO(216, 172, 124, 0.7)),
            ));
          });

      ResponseHttp response = await http.ReservarCita(
          this.selectedDate,
          this.selectedTime,
          this.barberoSeleccionado,
          this.tiempo,
          this.precio,
          this.serviciosSeleccionados);
      if (response.success == 1) {
        Navigator.of(context).pop();
        Alert(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
          context: context,
          type: AlertType.success,
          title: "CORRECTO",
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
                  _obtenerListaServicios();
                  tiempo = 10;
                  precio = 0;
                  selectedDate = DateTime.now();
                  selectedTime = TimeOfDay.now();
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
          title: "ERROR",
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
    } else {
      Alert(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "La hora de la cita no puede \n ser menor a la hora actual.",
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

  _validarFecha(DateTime fecha, TimeOfDay hora) {
    var fechaActual = DateTime.now();
    var horaActual = TimeOfDay.now();

    if (fechaActual.day == fecha.day &&
        fechaActual.month == fecha.month &&
        fechaActual.year == fecha.year) {
      if (horaActual.hour <= hora.hour) {
        double oa = horaActual.hour + horaActual.minute / 60.0;
        double os = hora.hour + hora.minute / 60.0;
        if (oa <= os) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
