import 'dart:io';
import 'package:alpinemessenger/models/userdata.dart';
import 'package:alpinemessenger/screens/groupChat.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as Path;

class group_details extends StatefulWidget {
  final List<User> selectedUsers;
  final List<int> length;
  group_details(this.selectedUsers, this.length , {Key key}) : super(key : key);
  @override
  _group_detailsState createState() => _group_detailsState();
}

class _group_detailsState extends State<group_details> {

  TextEditingController groupName = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  void initState(){
    super.initState();
    print(widget.length);
    print(widget.selectedUsers);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text( "New Group",style: TextStyle(
                fontFamily: 'Poppins',fontSize: 18.0
            ),overflow: TextOverflow.ellipsis,),
            Text("Enter Details",style: TextStyle(
                fontFamily: 'Poppins',fontSize: 14.0,color: Colors.white70
            ),overflow: TextOverflow.ellipsis,),
          ],
        ) ,
        centerTitle: true,
        leading:  IconButton(icon : Icon(Icons.arrow_back_ios),onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.blue[800],
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48.0),
            topRight: Radius.circular(48.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48.0),
            topRight: Radius.circular(48.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                   Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 65.0,
                          backgroundColor: Colors.blue[800],
                          child: GestureDetector(
                            onTap: (){
                              chooseFile().whenComplete((){
                                setState(() {
                                  Loading = true;
                                });
                                uploadFile().whenComplete((){

                                });
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: (_uploadedFileURL == null) ? Icon(Icons.camera_alt
                                , size: 30.0 , color: Colors.blue[800],) : null,
                              radius: 60.0,
                              backgroundImage: (_uploadedFileURL == null) ? null : NetworkImage(_uploadedFileURL),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text('Upload group display picture', style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 20.0 , fontFamily: 'Poppins'
                        ),)
                      ],
                    ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 10.0 , vertical: 25.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(20, 40, 227, .3),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white))
                              ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.people,color : Colors.blue[700]),
                                      hintText: 'Enter the group name',
                                      hintStyle: TextStyle(color : Colors.grey,fontFamily: 'Poppins'),
                                      border: InputBorder.none
                                  ),
                                 controller: groupName,
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Group name not entered.";
                                    }else{
                                      return null;
                                    }
                                  },
                                ),
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: RaisedButton(
                              splashColor: Colors.white,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  setState(() {
                                    isTapped = true;
                                  });
                                  groupChatRoom(globals.email, globals.name,groupName.text,_uploadedFileURL, widget.selectedUsers, widget.length.length).whenComplete((){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => new groupChat(groupName.text, '${globals.email}_${groupName.text}', _uploadedFileURL)));
                                  });
                                }
                              },
                              color: Colors.blue[800],
                              child:(isTapped) ? SizedBox(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ) : Text('Done' , style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins'
                              ),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 13.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 10.0 , vertical: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                              color: Color.fromRGBO(20, 40, 227, .3),
                              blurRadius: 20.0,
                              offset: Offset(0, 10)
                          )]
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('ADMIN : ',style: TextStyle(
                              fontFamily: 'Poppins' ,color: Colors.green,
                              fontWeight: FontWeight.w600
                            ),),
                            Text(' ${globals.name}',style: TextStyle(
                                fontFamily: 'Poppins'
                            ),),
                          ],
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 10.0 , vertical: 15.0),
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                              color: Color.fromRGBO(20, 40, 227, .3),
                              blurRadius: 20.0,
                              offset: Offset(0, 10)
                          )]
                      ),
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white))
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('USER ADDED : ',style: TextStyle(
                                  fontFamily: 'Poppins' ,color: Colors.green,
                                  fontWeight: FontWeight.w600
                              ),),
                              Text(' ${widget.length.length} Users',style: TextStyle(
                                  fontFamily: 'Poppins'
                              ),),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
