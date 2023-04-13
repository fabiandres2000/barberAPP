import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class Estadistica extends StatefulWidget {
  EstadisticaState createState() => new EstadisticaState();
}

class EstadisticaState extends State<Estadistica> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_3x.jpg'),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }

}