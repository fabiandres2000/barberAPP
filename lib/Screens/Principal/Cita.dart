import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Principal/Cita2.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:flutter_auth/modelos/Barbero.dart';
import 'package:flutter_auth/modelos/barberia.dart';
import 'package:flutter_auth/http/consultas.dart';

class Cita extends StatefulWidget {
  final Barberia barberiaSeleccionada;
  Cita(this.barberiaSeleccionada);
  CitaState createState() => new CitaState(barberiaSeleccionada);
}

class CitaState extends State<Cita> {
  bool loading = false;
  ConsultasHTTP consultas = new ConsultasHTTP();
  List<Barbero> barberos = [];
  List<Widget> widgets = [];
  String id;
  final Barberia barberiaSeleccionada;
  CitaState(this.barberiaSeleccionada);
  Size size;

  @override
  void initState() {
    super.initState();
    _obtenerListaBarberos();
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
        title: Center(child: Text("SOLIICITUD DE CITA")),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.merge_type),
            onPressed: () => print('hi on icon action'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fondo_3x.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 140),
          width: size.width,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  BaseUrl + "logos/" + barberiaSeleccionada.logo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Text(barberiaSeleccionada.nombre,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quick',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                        ),
                      ])),
              Text(barberiaSeleccionada.horario,
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
              Text(barberiaSeleccionada.direccion,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quick',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                        ),
                      ])),
              Text(barberiaSeleccionada.ciudad,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quick',
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 10,
                        ),
                      ])),
              _estrellas(barberiaSeleccionada.calificacion),
              Container(
                  height: 415,
                  child: loading
                      ? ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: barberos.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              leading: Image.network(
                                BaseUrl +
                                    "fotos_perfil/" +
                                    barberos[index].foto_perfil,
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              title: Text(barberos[index].nombre),
                              subtitle: Text(barberos[index].edad +
                                  " Años \n" +
                                  "Barber " +
                                  (index + 1).toString()),
                              trailing: Icon(Icons.arrow_right),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    BouncyPageRoute(
                                        widget: ReservaCita(barberos[index])));
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
                        ))
            ],
          ),
        ),
      ),
    );
  }

  _estrellas(String calificacion) {
    int numeroEstrellas = double.parse(calificacion).round();
    return Padding(
        padding: EdgeInsets.only(left: 70, right: 70),
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
            color: Colors.white,
          ),
        );
      } else {
        estrellas.add(Icon(
          Icons.star_border,
          size: 30,
          color: Colors.white,
        ));
      }
    }
    return estrellas;
  }

  Future<void> _obtenerListaBarberos() async {
    List<Barbero> respuesta;
    id = barberiaSeleccionada.id;
    respuesta = await consultas.listarBarberos(id);
    print(barberos);
    setState(() {
      barberos = [];
      barberos.addAll(respuesta);
      loading = true;
    });
  }
}
