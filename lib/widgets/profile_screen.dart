import 'dart:io';
import 'dart:math';
import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/loginpage.dart';
import 'package:alpinemessenger/services/google_sign_in.dart';
import 'package:alpinemessenger/services/linked_in_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class profile extends StatefulWidget {

  final String button;
  profile(this.button , {Key key}) : super(key : key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {

  File _image;
  String _uploadedFileURL;
  bool isTapped = false;
  bool Loading = false;

  Future chooseFile() async {
    await FilePicker.getFile(type: FileType.image).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  logOut() async{
    try {
      if (widget.button == 'normal_login'){
        FirebaseAuth.instance.signOut().then((value){
          print("Custom user logged out");
          Navigator.of(context).pushReplacementNamed('/loginpage');
        }).catchError((e){
          print(e);
        });
      } else if(widget.button == 'google'){
        signOutGoogle().whenComplete((){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => new login()
          ));
        });
      }else{
        setState(() {
          logOutLinkedIn = true;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => new login()
        ));
        print(globals.name);
      }
    }catch(e){
      print(e);
    }
  }

  void initState(){
    super.initState();
    print(widget.button);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 29.0,),
              GestureDetector(
                onTap: (){
                  chooseFile().whenComplete((){
                    setState(() {
                      Loading = true;
                    });
                    uploadFile().whenComplete(() async{
                     await Firestore.instance.collection("User").document(globals.email).updateData(
                        {
                          "display" : _uploadedFileURL
                        }
                      );
                     setState(() {
                       globals.Imageurl = _uploadedFileURL;
                     });
                    });
                  });
                },
                child: FadeAnimation(
                  1.2 , (globals.Imageurl == null) ? CircleAvatar(
                    radius: 75,backgroundColor: Colors.blue,
                    child: CircleAvatar(
                    radius: 70,
                    foregroundColor: Colors.blue[800],
                    backgroundColor: Colors.white,
                    child: Text(globals.name[0],style: TextStyle(
                        fontFamily: 'Poppins' , fontSize: 50.0 , color: Colors.blue[800]
                    ),),
                ),
                  ) : CircleAvatar(
                  radius: 75,backgroundColor: Colors.blue,
                    child: CircleAvatar(
                    radius: 70,
                    foregroundColor: Colors.blue[800],
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(globals.Imageurl),
                ),
                  ),
                ),
              ),
              SizedBox(height: 1.0,),
              FadeAnimation(
                1.3 , Container(
                  width: MediaQuery.of(context).size.width*0.94,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          Center(
                            child: Text(globals.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 25.0,
                              letterSpacing: 1.0,
                              fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                      Text(globals.role,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              FadeAnimation(
                1.5 , Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 4.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[800],
                          Colors.blue[600],
                          Colors.blue[400]
                        ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(20, 40, 227, .3),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )]
                  ),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.5, color: Colors.white))),
                      child: Icon(Icons.email, color: Colors.white),
                    ),
                    title: Text( globals.email ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontFamily: 'Poppins',

                      ),),
                  )
                ),
              ),
              SizedBox(height: 10.0,),
              FadeAnimation(
                1.5 , Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 4.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.blue[800],
                            Colors.blue[600],
                            Colors.blue[400]
                          ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(20, 40, 227, .3),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )]
                  ),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.5, color: Colors.white))),
                      child: Icon(Icons.phone, color: Colors.white),
                    ),
                    title: Text( globals.phone ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontFamily: 'Poppins',

                      ),),
                  )
              ),
              ),
              SizedBox(height: 10.0,),
              FadeAnimation(
                1.5 , Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 4.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.blue[800],
                            Colors.blue[600],
                            Colors.blue[400]
                          ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(20, 40, 227, .3),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )]
                  ),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.5, color: Colors.white))),
                      child: Icon(Icons.cake, color: Colors.white),
                    ),
                    title: Text( globals.dob ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontFamily: 'Poppins',

                      ),),
                  )
              ),
              ),
              SizedBox(height: 10.0,),
              FadeAnimation(
                1.5 , Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 4.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.blue[800],
                            Colors.blue[600],
                            Colors.blue[400]
                          ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(20, 40, 227, .3),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )]
                  ),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.5, color: Colors.white))),
                      child: Icon(Icons.credit_card, color: Colors.white),
                    ),
                    title: Text( globals.pan_number ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontFamily: 'Poppins',

                      ),),
                  )
              ),
              ),
              SizedBox(height: 20.0,),
              FadeAnimation(
                1.5 , Container(
                  width: MediaQuery.of(context).size.width*0.65,
                  padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 4.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.blue[800],
                            Colors.blue[600],
                            Colors.blue[400]
                          ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                          color: Color.fromRGBO(20, 40, 227, .3),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                      )]
                  ),
                  child: GestureDetector(
                    onTap: (){
                      logOut();
                    },
                    child: ListTile(
                      dense: true,
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.5, color: Colors.white))),
                        child: Icon(Icons.exit_to_app, color: Colors.white),
                      ),
                      title: Text( 'LOGOUT' ,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontFamily: 'Poppins',
                        ),),
                    ),
                  )
              ),
              ),
              SizedBox(height: 20.0,)
            ],
          ),
        ),
      ),
    );
  }
}
