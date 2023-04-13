import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Barberia/Barberia.dart';
import 'package:flutter_auth/Screens/Principal/Principal.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carga extends StatefulWidget {
  _CargaState createState() => new _CargaState();
}


class _CargaState extends State<Carga> {

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: double.infinity,
              height: 200,
              child:  
                Image.asset(
                  "assets/icons/back4.png",
                   width: size.width * 0.5,
              ),
            )
          ),
           Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color.fromRGBO(216,172,124, 0.7)),
              backgroundColor: Colors.black,
              strokeWidth: 7,
            ),
          )
        ],
      ),
    );
  }


  Future<void> _verificarSesion()  async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    new Future.delayed(new Duration(seconds: 3),(){
      var tipo =  pref.getString('tipo');
      if(tipo == "Usuario"){
        Navigator.push(
          context,
          BouncyPageRoute(widget: Principal())
        );   
      }else{
        if(tipo == "Barberia"){
            Navigator.push(
              context,
              BouncyPageRoute(widget: BarberiaStateless())
            );   
        }else{
          Navigator.push(
            context,
            BouncyPageRoute(widget: LoginPage())
          );
        }
      }            
    });
  }
}
