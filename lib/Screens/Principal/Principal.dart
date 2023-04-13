import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Mapa/antesMapa.dart';
import 'package:flutter_auth/Screens/Principal/AppBar.dart';
import 'package:flutter_auth/Screens/Principal/Barberias.dart';
import 'package:flutter_auth/Screens/Principal/BottonBar.dart';
import 'package:flutter_auth/Screens/Principal/MisCitas.dart';

class Principal extends StatefulWidget {
  _principalState createState() => new _principalState();
}

class _principalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  TabController controlador_menu;
  @override
  void initState() {
    super.initState();
    controlador_menu = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppbarPrincipal().Menu(context),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fondo_2x.png'),
                fit: BoxFit.cover)),
        child: TabBarView(
          children: <Widget>[new Barberias(), new MisCitas(), new AntesMapa()],
          controller: controlador_menu,
        ),
      ),
      bottomNavigationBar: BottonBarM(controlador_menu).MenuBotton(context),
    );
  }
}
