import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class BottonBarM {
  final TabController controlador_menu;
  BottonBarM(this.controlador_menu);
  Widget MenuBotton(BuildContext context) {
    return Material(
      color: ColorMenu,
      child: new TabBar(
        tabs: <Tab>[
          new Tab(
            icon: Icon(Icons.cut_rounded, color: Colors.white),
            text: 'Barberias',
          ),
          new Tab(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            text: 'Mis Citas',
          ),
          new Tab(
            icon: Icon(Icons.map, color: Colors.white),
            text: 'Mapa',
          ),
        ],
        labelColor: Colors.white,
        controller: controlador_menu,
      ),
    );
  }
}
