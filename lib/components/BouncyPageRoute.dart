import 'package:flutter/cupertino.dart';

class  BouncyPageRoute extends PageRouteBuilder {

  final Widget widget;

  BouncyPageRoute({this.widget}):super(
    transitionDuration: Duration(seconds: 1),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secanimation, Widget child){
      animation = CurvedAnimation(parent: animation, curve: Curves.ease);
      return ScaleTransition(
        alignment: Alignment.centerRight,
        scale: animation,
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secanimation){
      return widget;
    }              
  );
  

}