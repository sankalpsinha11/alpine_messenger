import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class displayView extends StatefulWidget {
  final String display;
  displayView(this.display , {Key key}) :  super(key : key);
  @override
  _displayViewState createState() => _displayViewState();
}

class _displayViewState extends State<displayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Picture',style: TextStyle(
          fontFamily: 'Poppins'
        ),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.display),
        ),
      ),
    );
  }
}
