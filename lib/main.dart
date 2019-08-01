import 'package:flutter/material.dart';
import './Botona.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()async => runApp(new MaterialApp(home:MyApp()) );

class MyApp extends StatelessWidget{

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
          children: <Widget>[Text('Veuillez commencer par le recto:'),
            Botona('camera'),
            Botona('gallery'),
          ],
          // This trailing comma makes auto-formatting nicer for build methods.
        ),),);
  }
}


