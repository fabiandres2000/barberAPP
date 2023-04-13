import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Barberia/components/RegistroBarbero.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/http/constant.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/modelos/Barbero.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTeam extends StatefulWidget {
  MyTeamState createState() => new MyTeamState();
}

class MyTeamState extends State<MyTeam> {
  bool loading = false;
  ConsultasHTTP consultas = new ConsultasHTTP();
  List<Barbero> barberos = [];
  List<Widget> widgets = [];
  String id;

  @override
  void initState() {
    super.initState();
    _obtenerLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/myteams.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            SizedBox(height: 130),
            _botonAgregar(),
            Container(
                height: 515,
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
                            trailing: Icon(Icons.edit),
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
    );
  }

  _botonAgregar() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        primary: Color.fromRGBO(216, 172, 124, 1),
        textStyle: const TextStyle(fontSize: 20));
    final ButtonStyle style2 = ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        primary: Colors.black,
        textStyle: const TextStyle(fontSize: 20));

    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: style,
          onPressed: () {
            Navigator.push(context, BouncyPageRoute(widget: RegistroBarbero()));
          },
          child: const Text('Registrar'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: style2,
          onPressed: () {
            setState(() {
              loading = false;
              _obtenerLista();
            });
          },
          child: const Text('Actualizar'),
        ),
      ],
    ));
  }

  Future<void> _obtenerLista() async {
    List<Barbero> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id');
    respuesta = await consultas.listarBarberos(id);
    print(barberos);
    setState(() {
      barberos = [];
      barberos.addAll(respuesta);
      loading = true;
    });
  }
}
