import 'package:flutter/material.dart';
import 'package:flutter_auth/components/BouncyPageRoute.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class AppbarBaeberia {
  Widget Menu(BuildContext context) {
   return  AppBar(
          toolbarHeight: 100,
          backgroundColor: ColorMenu,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => print('hi on menu icon'),
              );
            },
          ), 
          title: Container(
            child: Center(
              child: Text(
                "MI BARBERIA"
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.login),
              onPressed: () {
                SweetAlert.show(context,
                  title: "Cerrando sesión",
                  subtitle: "¿realmente desea cerrar sesión?",
                  style: SweetAlertStyle.confirm,
                  cancelButtonText: "No",
                  confirmButtonText: "Si",
                  confirmButtonColor: Colors.black,
                  cancelButtonColor: Color.fromRGBO(216,172,124, 1),
                  showCancelButton: true, onPress: (bool isConfirm) {
                     if (isConfirm) {
                        //Return false to keep dialog
                          if(isConfirm){
                            _borrarDatos(context);
                          }
                        return false;
                     }
                  }
                );
              },
            ),
          ],
        );
  }
  Future <void> _borrarDatos(BuildContext context) async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.push(
    context,
      BouncyPageRoute(widget: LoginPage())
    );
  } 
}