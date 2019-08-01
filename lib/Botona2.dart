import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import './infos.dart';


class Botona2 extends StatefulWidget{
  final String mode;
  List<TextLine> list =[] ;

  Botona2(this.mode,this.list);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Botona2State();
  }}

class _Botona2State extends State<Botona2>{
  String _option;
  VisionText _visionText;
  List<TextLine> _list1 =[] ;
  List<TextLine> _list2 =[] ;
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
  String _pass=''' ''';
  @override
  void initState() {
    _option=widget.mode;
    _list1=widget.list;
    super.initState();
  }
  @override
  void didUpdateWidget(Botona2 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }
  bool isNumber(String str){
    bool bol=false;
    for(String e in ['0','1','2','3','4','5','6','7','8','9']){if(e==str){bol=true; break;}}
  }
  void _sendData(List<TextLine> list1, List<TextLine> list2){
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
    /*Firestore.instance.collection('CINs').add({
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
    });*/


  }


  IconData getIcon(){
    if(_option=='camera') {
      return Icons.add_a_photo;
    }
    else{
      return Icons.add_photo_alternate;
    }
  }


  String getTitle(){
    if(_option=='camera'){
      return '   Scan CIN using Camera';
    }
    else{
      return '   Scan CIN using Gallery';
    }
  }

  Future _getImage()async {
    try  {if(_option=='camera'){
      final File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,);
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 0.63,
        //maxWidth: 1000,
        //maxHeight: 1000,
      );
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(croppedFile);
      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      final VisionText visionText = await textRecognizer.processImage(visionImage);
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          _list2.add(line);
        }
      }
      setState(()  {
        _visionText= visionText;
        //_sendData(_list1, _list2);
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){return new Infos(_list1,_list2);}));
      });

    }
    else{
      final File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,);
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 0.63,
        //maxWidth: 1000,
        //maxHeight: 1000,
      );
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(croppedFile);
      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      final VisionText visionText = await textRecognizer.processImage(visionImage);
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          _list2.add(line);
        }
      }
      setState(() {
        _visionText=  visionText;
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){return new Infos(_list1,_list2);}));
      }
      );




    }}
    catch(e) {
      print(e);
    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(margin: EdgeInsets.all(20.0),
      child: SizedBox(width: 220.0,
        height: 50.0,
        child: RaisedButton(color: Colors.green,
          splashColor: Colors.greenAccent,
          onPressed: () {_getImage();

          },
          child: Row(children: <Widget>[Icon(getIcon()), Text(getTitle()),],),),),);
  }
}
