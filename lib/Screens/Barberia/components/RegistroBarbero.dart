import 'package:flutter/material.dart';
import 'package:flutter_auth/http/Barbero.dart';
import 'package:flutter_auth/http/response.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';



class RegistroBarbero extends StatefulWidget {
  RegistroBarberoState createState() => new RegistroBarberoState();
}

class RegistroBarberoState extends State<RegistroBarbero>  {
  File imagen;
  final picker = ImagePicker();
  String idBarberia;
  String nombreBarberia;
  TextEditingController idbarberia;
  TextEditingController nombrebarberia;
  TextEditingController nombre = new TextEditingController();
  TextEditingController edad = new TextEditingController();
  BarberoHttp barberoHttp = new BarberoHttp();

  @override
  void initState() {
    super.initState();
    datosBarberia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.black,
          title: Text("REGISTRO DE BARBERO"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: body(),
      ),
    );
  }

  body(){
   return ListView( children: <Widget>[ 
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imagen != null? SizedBox(height: 40) : SizedBox(height: 80),
            Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: imagen != null?  Image.file(
                    imagen,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ) : Center(),
                ),
              )
            ),
            imagen == null? Container(
              child: Column(
                children: <Widget> [
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () => _seleccionarImagen(),
                    child: const Icon(Icons.camera_alt),
                  ),
                  Text("(Foto de perfil)")
                ],
              ),
            )  : Center(),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Nombre',
              ),
              controller: nombre,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Edad',
              ),
              controller: edad,
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(Icons.location_city_outlined),
              ),
              controller: idbarberia,
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                icon: Icon(Icons.location_city_outlined),
                labelText: nombreBarberia
              ),
              controller: nombrebarberia,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                fixedSize: const Size(3000, 40)
              ),
              onPressed: () {
                _guardarBarbero();
              },
              child: const Text(
                "Registrar"
              ),
            ),
            imagen != null? SizedBox(height: 40): SizedBox(height: 70),
            Center(
              child: Image.asset(
                'assets/images/barberia.png',
                height: 40,
              ),
            )
          ],
        )
      ]
    );
  }

  Future _seleccionarImagen() async {
    var picketfile;
    picketfile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(picketfile != null){
        imagen = File(picketfile.path);
      }
    });
  }

  Future <void> datosBarberia() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idBarberia = preferences.getString('id');
      nombreBarberia = preferences.getString('nombre');
      idbarberia = new TextEditingController(text:  idBarberia);
      nombrebarberia = new TextEditingController(text:  nombreBarberia);
    });
    
  } 
  
  Future<void> _guardarBarbero() async{ 
    SweetAlert.show(context,subtitle: "Guardando datos...", style: SweetAlertStyle.loading); 
    ResponseHttp response =  await barberoHttp.RegistrarBarbero(imagen, nombre.text, edad.text,idbarberia.text);
    if(response.success == 1){
       SweetAlert.show(
        context,
        subtitle: response.mensaje, 
        style: SweetAlertStyle.success,
        confirmButtonText: "OK",
        onPress: (bool isConfirm) {
          if (isConfirm) {
            setState(() {
              nombre = new TextEditingController();
              edad = new TextEditingController();
              imagen = null;
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
