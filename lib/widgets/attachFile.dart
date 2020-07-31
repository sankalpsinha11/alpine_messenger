import 'dart:io';
import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class attachFileType extends StatefulWidget {
  final String chatRoomID;
  final String sender;
  final String chatType;
  attachFileType(this.chatRoomID , this.sender ,this.chatType , {Key key}) : super(key : key);
  @override
  _attachFileTypeState createState() => _attachFileTypeState();
}

class _attachFileTypeState extends State<attachFileType> {

  File file;

  Future getFile(FileType fileType) async {
    var tempfile = await FilePicker.getFile(type: fileType);
    setState(() {
      file = tempfile;
    });
    (file == null) ? print("Empty") : print("got it here");
  }

  //Method to upload any file sent by the user

  Future uploadFile(File file , String messageType)  async{
    StorageReference ref = FirebaseStorage.instance.ref().child('${widget.chatRoomID}/${widget.sender}_${DateTime.now().toIso8601String()}');
    StorageTaskSnapshot storageTaskSnapshot;
    await ref.putFile(file).onComplete.then((value){
      if(value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadURL){
          if(widget.chatType == 'single') {

          }else {
            addGroupMessage("chat",widget.chatRoomID, downloadURL, messageType);
          }
        });
      }else{
        showToast('No file sent.' ,
            context:  context,
            borderRadius: BorderRadius.circular(10.0),
            animation: StyledToastAnimation.fade,
            backgroundColor: Colors.blue[400],
            position: StyledToastPosition.center,
            alignment: Alignment.center
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0 , horizontal: 20.0),
      child:  Wrap(
        children: <Widget>[
          Card(
            color: Colors.blue[50],
            elevation: 5.0,
            child: ListTile(
                leading:  Container(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.image, color: Colors.blue[800]),
                ),
                title:  Text('Send an Image' , style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Poppins'
                ),),
                trailing: Icon(Icons.arrow_forward,color: Colors.blue[800],),
                onTap: () {
                  getFile
                    (FileType.image).whenComplete(() {
                    Navigator.of(context).pop();
                     if(file == null) {
                       showToast('No file selected.' ,
                           context:  context,
                           borderRadius: BorderRadius.circular(10.0),
                           animation: StyledToastAnimation.fade,
                           backgroundColor: Colors.blue[400],
                           position: StyledToastPosition.center,
                         alignment: Alignment.center
                       );
                     }
                     else{
                      try{
                        uploadFile(file , 'image').whenComplete((){
                         print("Uploaded");
                       });}catch(e){
                        print(e);
                      }
                       showToast('Sending...' ,
                           context:  context,
                      borderRadius: BorderRadius.circular(10.0),
                      animation: StyledToastAnimation.fade,
                           backgroundColor: Colors.blue[400],
                           position: StyledToastPosition.center,
                           alignment: Alignment.center
                    );
                     }
                  });
                }
            ),
          ),
          Card(
            color: Colors.blue[50],
            elevation: 5.0,
            child: ListTile(
                leading:  Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.blue[800]))),
                  child: Icon(Icons.videocam, color: Colors.blue[800]),
                ),
                title:  Text('Send a Video' , style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 20.0,
                    fontFamily: 'Poppins'
                ),),
                trailing: Icon(Icons.arrow_forward,color: Colors.blue[800],),
                onTap: () {
                  getFile
                    (FileType.video).whenComplete(() {
                    Navigator.of(context).pop();
                    if(file == null) {
                      showToast('No file selected.' ,
                          context:  context,
                          borderRadius: BorderRadius.circular(10.0),
                          animation: StyledToastAnimation.fade,
                          backgroundColor: Colors.blue[400],
                          position: StyledToastPosition.center,
                          alignment: Alignment.center
                      );
                    }
                    else{
                      try{
                        uploadFile(file , 'video').whenComplete((){
                          print("Uploaded");
                        });}catch(e){
                        print(e);
                      }
                      showToast('Sending...' ,
                          context:  context,
                          borderRadius: BorderRadius.circular(10.0),
                          animation: StyledToastAnimation.fade,
                          backgroundColor: Colors.blue[400],
                          position: StyledToastPosition.center,
                          alignment: Alignment.center
                      );
                    }
                  });
                }
            ),
          ),
          Card(
            color: Colors.blue[50],
            elevation: 5.0,
            child: ListTile(
                leading:  Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.blue[800]))),
                  child: Icon(Icons.insert_drive_file, color: Colors.blue[800]),
                ),
                title:  Text('Send a File' , style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 20.0,
                    fontFamily: 'Poppins'
                ),),
                trailing: Icon(Icons.arrow_forward,color: Colors.blue[800],),
                onTap: () {
                  getFile
                    (FileType.any).whenComplete(() {
                    Navigator.of(context).pop();
                    if(file == null) {
                      showToast('No file selected.' ,
                          context:  context,
                          borderRadius: BorderRadius.circular(10.0),
                          animation: StyledToastAnimation.fade,
                          backgroundColor: Colors.blue[400],
                          position: StyledToastPosition.center,
                          alignment: Alignment.center
                      );
                    }
                    else{
                      try{
                        uploadFile(file , 'file').whenComplete((){
                          print("Uploaded");
                        });}catch(e){
                        print(e);
                      }
                      showToast('Sending...' ,
                          context:  context,
                          borderRadius: BorderRadius.circular(10.0),
                          animation: StyledToastAnimation.fade,
                          backgroundColor: Colors.blue[400],
                          position: StyledToastPosition.center,
                          alignment: Alignment.center
                      );
                    }
                  });
                }
            ),
          ),
        ],
      ),
    );
  }

}


