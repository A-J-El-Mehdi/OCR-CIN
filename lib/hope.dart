import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



String _nom;
String _prenom;
String _date_naiss;
String _date_exp;
String _lieu_naiss;
String _n_cin;
String _pere;
String _mere;
String _adresse;
String _etat_civil;
bool _date=false;
bool _name=false;
bool isUppercase(String str) {
  return str == str.toUpperCase();
}
bool isNumber(String str){
  bool bol=false;
  for(String e in ['0','1','2','3','4','5','6','7','8','9']){if(e==str){bol=true; break;}}
}
void sendData(List<TextLine> list1, List<TextLine> list2){
  for (TextLine line in list1) {
    if (((isUppercase(line.text))&&(line.text.substring(2,3)!='.')&&(isNumber(line.text.substring(4,5))==false) && (line.text.substring(0,9)!='ROYAUME D') && (line.text.substring(0,9)!='CARTE NAT') )){
      if(_name==false){
        _prenom=line.text;
        _name=true;
      }
      else _nom=line.text;
    }
    if(line.text.substring(2,3)=='.'){
      if(_date==false){
        _date_naiss=line.text;
        _date=true;
      }
      else _date_exp=line.text;
    }
    if(line.text.substring(0,1)=='à'){
      _lieu_naiss=line.text.substring(1);
    }

  }
  for(TextLine line in list2){
    if(line.text.substring(0,7)=='Fils de'){
      _pere=line.text.substring(8);
    }
    if(line.text.substring(0,5)=='et de'){
      _mere=line.text.substring(6);
    }
    if(line.text.substring(3,4)=='/'){
      _etat_civil=line.text;
    }
    if(line.text.substring(0,7)=='Adresse'){
      int i= list2.indexOf(line);
      _adresse=line.text.substring(8)+' '+list2[i+1].text;
    }
    for(TextLine line2 in list1){
      if(line==line2 && line.text.substring(2,3)!='.'){
        _n_cin=line.text; break;
      }
    }
  }
  Firestore.instance.collection('CINs').add({
    "Nom": _nom,
    "Prénom": _prenom,
    "N° CIN": _n_cin,
    "Date de naissance": _date_naiss,
    "Lieu de naissance": _lieu_naiss,
    "Date d'expiration": _date_exp,
    "Nom du père": _pere,
    "Nom de la mère": _mere,
    "Adresse": _adresse,
    "N°état civil": _etat_civil
  });
}
