import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Barberia/components/Appbar.dart';
import 'package:flutter_auth/Screens/Barberia/components/Estadistica.dart';
import 'package:flutter_auth/Screens/Barberia/components/Home.dart';
import 'package:flutter_auth/Screens/Barberia/components/Myteam.dart';
import 'package:flutter_auth/Screens/Barberia/components/bottonBar.dart';


class BarberiaStateless extends StatefulWidget {
  _BarberiaState createState() => new _BarberiaState();
}

class _BarberiaState extends State<BarberiaStateless> with SingleTickerProviderStateMixin {
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
      appBar: AppbarBaeberia().Menu(context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_2x.png'),
            fit: BoxFit.cover
          )
        ),
        child: TabBarView(
          children: <Widget>[ new Home(),new MyTeam(), new Estadistica()],
          controller: controlador_menu,
        ),
      ), 
      bottomNavigationBar: BottonBarBarberia(controlador_menu).MenuBotton(context),
    );
  }

}

