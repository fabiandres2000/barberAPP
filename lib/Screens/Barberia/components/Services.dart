import 'package:flutter/material.dart';
import 'package:flutter_auth/http/Servicio.dart';
import 'package:flutter_auth/http/consultas.dart';
import 'package:flutter_auth/http/response.dart';
import 'package:flutter_auth/modelos/Servicio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';


class Services extends StatefulWidget {
  ServicesState createState() => new ServicesState();
}

class ServicesState extends State<Services> {

  bool loading = false;
  ConsultasHTTP consultas = new ConsultasHTTP();
  TextEditingController nombre = new TextEditingController();
  TextEditingController precio = new TextEditingController();
  TextEditingController duracion = new TextEditingController();
  List<Servicio> servicios = [];
  String id_barberia;
  ServicioHttp servicioHttp = new ServicioHttp();

  @override
  void initState() {
    super.initState();
    _obtenerListaServicios();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.black,
          title: Text("SERVICIOS REGISTRADOS"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_3x.jpg'),
            fit: BoxFit.cover
          )
        ),
        child:Column(
          children: <Widget>[
            SizedBox(height: 140),
            _botonAgregar(),
            Container(
              height: 565,
              child: loading? ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: servicios.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget> [
                        Text(
                          (index+1).toString(),
                          style: TextStyle(fontSize: 30),
                        )
                      ]
                    ),
                    contentPadding: EdgeInsets.all(10),
                    title: Text("Nombre: "+servicios[index].nombre),
                    subtitle: Text("Precio: "+servicios[index].precio+" Pesos. \n"+"Duracion:  "+servicios[index].tiempo+" minutos"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                      },
                    ),
                  )
                );
              }
            ):Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color.fromRGBO(216,172,124, 0.7)),
                backgroundColor: Colors.transparent,
                strokeWidth: 7,
              ),
            ),
          )
        ]
      )
    )
  );
  }

  Future<void> _obtenerListaServicios() async {
    List<Servicio> respuesta;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id_barberia = preferences.getString('id');
    respuesta = await consultas.listarServicios(id_barberia);
    print(respuesta);
    setState(() {
      servicios = [];
      servicios.addAll(respuesta);
      loading = true;
    });
  }


  _botonAgregar(){
    final ButtonStyle style = ElevatedButton.styleFrom(shadowColor: Colors.white,primary: Color.fromRGBO(216,172,124, 1),textStyle: const TextStyle(fontSize: 20));
    return Center(
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: style,
            onPressed: () {
              _onAlertWithCustomContentPressed(context);
            },
            child: const Text('Registrar Servicio'),
          ),
        ],
      )
    );
  }

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "Registro de Servicio",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.qr_code_rounded),
                labelText: 'Nombre del servicio',
              ),
              controller: nombre,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.price_change),
                labelText: 'Precio  del servicio',
              ),
              controller: precio,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.watch_later_rounded),
                labelText: 'Duracion del servicio',
              ),
              controller: duracion,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.black,
            onPressed: () => _guardarServicio(),
            child: Text(
              "Guardar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Future<void> _guardarServicio() async{
    Navigator.pop(context);
    SweetAlert.show(context,subtitle: "Guardando datos...", style: SweetAlertStyle.loading); 
    ResponseHttp response =  await servicioHttp.RegistrarServicio(nombre.text, precio.text, duracion.text, id_barberia);
    if(response.success == 1){
       SweetAlert.show(
        context,
        subtitle: response.mensaje, 
        style: SweetAlertStyle.success,
        confirmButtonText: "OK",
        onPress: (bool isConfirm) {
          if (isConfirm) {
            setState(() {
              loading = false;
              nombre = new TextEditingController();
              precio = new TextEditingController();
              duracion = new TextEditingController();
              _obtenerListaServicios();
            });
          }
        }
      );
    }else{
      SweetAlert.show(
        context,
        subtitle: response.mensaje, 
        style: SweetAlertStyle.error
      );
    }
  }
}