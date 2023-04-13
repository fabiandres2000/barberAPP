import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';


class BottonBarBarberia {
  final TabController controlador_menu;
  BottonBarBarberia(this.controlador_menu);
  Widget MenuBotton(BuildContext context) {
    return Material(
      color: ColorMenu,
      child: new TabBar(
         tabs: <Tab> [
           new Tab(
              icon: Icon(Icons.home, color: Colors.white),
              text: 'Inicio',
           ),
           new Tab(
              icon: Icon(Icons.group, color: Colors.white),
              text: 'Equipo',
           ),
           new Tab(
              icon: Icon(Icons.bar_chart, color: Colors.white),
              text: 'Reporte',
           ),
         ],
         labelColor: Colors.white,
         controller: controlador_menu,
      ),
    );
  }
}