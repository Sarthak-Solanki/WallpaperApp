import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'FullScreenView.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
const String testDevice = '';

class WallScreen extends StatefulWidget {

  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
  Firestore.instance.collection("WallPaper");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });

    // _currentScreen();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Wallfy"),
        ),
        body: wallpapersList != null
            ? new StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpapersList.length,
          itemBuilder: (context, i) {
            String imgPath = wallpapersList[i].data['URL'];
            return new Material(
              elevation: 8.0,
              borderRadius:
              new BorderRadius.all(new Radius.circular(8.0)),
              /*child: new CachedNetworkImage(
                placeholder: new CircularProgressIndicator(),
                imageUrl: imgPath,
                fit: BoxFit.cover,
                //AssetImage("assets/wallfy.png"),
              ),*/
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new FullScreenImagePage(imgPath)));
                },
                child: new Hero(
                  tag: imgPath,
                  child: new CachedNetworkImage(
                    //placeholder: new CircularProgressIndicator(),
                    imageUrl: imgPath,
                    fit: BoxFit.cover,
                    //AssetImage("assets/wallfy.png"),
                  ),

                  /*new FadeInImage(
                    image: new NetworkImage(imgPath),
                    fit: BoxFit.cover,
                    placeholder: new AssetImage("assets/wallfy.png"),
                  ),*/
                ),
              ),
            );
          },
          staggeredTileBuilder: (i) =>
          new StaggeredTile.count(2, i.isEven ? 2 : 3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        )
            : new Center(
          child: new CircularProgressIndicator(),
        ));
  }
}
class wally extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new WallScreen(),
    );
  }

}
void main() => runApp(new wally());