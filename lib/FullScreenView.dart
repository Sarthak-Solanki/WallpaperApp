import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';

class FullScreenImagePage extends StatefulWidget{
  String imgPath;
  FullScreenImagePage(this.imgPath);

  @override
  FullScreenImagePages createState() => new FullScreenImagePages();
}

class FullScreenImagePages extends State<FullScreenImagePage> {

  var _imageFile;
  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);


  void _onImageSaveButtonPressed() async {
    print("_onImageSaveButtonPressed");
    var response = await http
        .get(widget.imgPath);

    debugPrint(response.statusCode.toString());

    var filePath = await ImagePickerSaver.saveFile(
        fileData: response.bodyBytes);

    var savedFile= File.fromUri(Uri.file(filePath));
       _imageFile = Future<File>.sync(() => savedFile);

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(gradient: backgroundGradient),
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child: new Hero(
                  tag: widget.imgPath,
                  child: new Image.network(widget.imgPath),
                ),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: new FlatButton(onPressed: (){
        _onImageSaveButtonPressed();
      }, child: new Icon(Icons.save)),
    );
  }
}