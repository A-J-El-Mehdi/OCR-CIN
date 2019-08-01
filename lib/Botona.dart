import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import './main2.dart';


class Botona extends StatefulWidget{
  final String mode;
  Botona(this.mode);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BotonaState();
  }}

  class _BotonaState extends State<Botona>{
  String _option;

  List<TextLine> _list =[] ;
  @override
  void initState() {
    _option=widget.mode;
    super.initState();
  }
  @override
  void didUpdateWidget(Botona oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
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
          _list.add(line);
        }
      }
      setState(()  {

        Navigator.of(context).push(new MaterialPageRoute(builder: (context){return new Main2(_list);}));
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
          _list.add(line);
        }
      }
print(visionText.text);
      setState(() {

        Navigator.of(context).push(new MaterialPageRoute(builder: (context){return new Main2(_list);}));
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
