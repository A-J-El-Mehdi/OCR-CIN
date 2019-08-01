import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import './Botona2.dart';

class Main2 extends StatelessWidget{
  Main2(this.list);
  List<TextLine> list =[] ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

        title: Text('Reconnaissance optique de CIN'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Au tour du verso maintenant:'),
            Botona2('camera',list),
            Botona2('gallery',list),
          ],
          // This trailing comma makes auto-formatting nicer for build methods.
        ),),);
  }
}