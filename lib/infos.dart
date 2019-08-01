import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';



class Infos extends StatelessWidget {
  Infos(this.list1,this.list2);
  List<TextLine> list1;
  List<TextLine> list2;


  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }
  bool isNumber(String str){
    bool bol=false;
    for(String e in ['0','1','2','3','4','5','6','7','8','9']){if(e==str){bol=true; break;}
    }
    return bol;
  }

  bool isContainingNumber(String str){
    for(int i=0 ;i< str.length ; i++){
      if(isNumber(str[i])){return true; break;}
    }
    return false;
  }
  bool isCIN(String str){
    if(str.length>4){
      if(isNumber(str[2]) && isNumber(str[3]) && isNumber(str[4]) && !isNumber(str[0]) && isUppercase(str[0]) && isUppercase(str[1])){
        return true;
      }
      else {return false;}
    }
    else {return false;}
  }

  void sendData(List<TextLine> list1, List<TextLine> list2){
    String nom;
    String prenom;
    String date_naiss;
    String date_exp;
    String lieu_naiss;
    String n_cin;
    String pere;
    String mere;
    String adresse="";
    String etat_civil;
    bool date=false;
    bool name=false;
    bool isDate = false;


    print(list1[1].text + "SSS" + list2[1].text);
    for (TextLine line in list1) {
      isDate = (line.text.contains('.'));

      if (((line.text.length>2 && isUppercase(line.text))&&(!isDate)&&(!isContainingNumber(line.text)) && (!line.text.contains('ROYAUME D')) && (!line.text.contains('CARTE NAT')) )){
        if(name==false){
          prenom=line.text;
          name=true;
        }
        else nom=line.text;
      }
      if(isDate){
        if(date==false){
          date_naiss=line.text;
          date=true;
        }
        else date_exp=line.text;
      }
      if(line.text.substring(0,1)=='à'){
        lieu_naiss=line.text.substring(1);
      }
      if (isCIN(line.text)){
        n_cin=line.text;
      }

    }
    for(TextLine line in list2){
      if(line.text.contains('Fils de') || line.text.contains('Fille de')){
        pere=line.text.substring(8);
      }
      if(line.text.contains('et de')){
        mere=line.text.substring(6);
      }
      if(line.text.contains('/')){
        etat_civil=line.text;
      }
      if(line.text.contains('Adresse')){
        if(line.text.length >= 9){
          adresse=line.text.substring(8);
        }
      }

    }
    var map= {
      'Nom': nom,
      'Prénom': prenom,
      'N° CIN': n_cin,
      'Date de naissance': date_naiss,
      'Lieu de naissance': lieu_naiss,
      'Date expiration': date_exp,
      'Nom du père': pere,
      'Nom de la mère': mere,
      'Adresse': adresse,
      'N°état civil': etat_civil
    };
    print(nom + " " + n_cin);

   // Firestore.instance.collection('CINs').add(map).catchError((err) => print(err));
    print(adresse);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(Firestore.instance.collection("CINs").document(), map);
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(

      title: Text('Finalisez votre Scan'),
    ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Veuillez appuyer sur ce Bouton pour finaliser votre scan'),
            RaisedButton(color: Colors.green,
              splashColor: Colors.greenAccent,
              onPressed: () {sendData(list1, list2);

              },
              child: Icon(Icons.check),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(70.70)),),

          ],
          // This trailing comma makes auto-formatting nicer for build methods.
        ),)
      ,);
  }
}