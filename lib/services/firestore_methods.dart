import 'dart:io';
import 'package:alpinemessenger/models/userdata.dart';
import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:alpinemessenger/widgets/formGroups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//to fetch details of the logged in user via normal login method

bool error_in_login = false;

Future getDetails(email) async {
  try {
    DocumentReference docs = Firestore.instance.collection('User').document(email);
    await docs.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        globals.email = datasnapshot.data['email'];
        globals.name = datasnapshot.data['Name'];
        globals.pan_number = datasnapshot.data['Pan/Aadhar Number'];
        globals.phone = datasnapshot.data['Phone Number'];
        globals.dob = datasnapshot.data['Date of birth'];
        globals.role = datasnapshot.data['Role'];
        globals.Imageurl = datasnapshot.data['display'];
        print("Done");
        error_in_login = false;
      }
      else {
        print("No such User");
        error_in_login = true;
      }
    });
  } catch(e){
    error_in_login = true;
    print(e);
  }
}

//Method to store user details in firestore when signing up



Future adduser(name , String token , _email  , _dob , _phone_number , _pan ,_currentItem) async {

  try {
    var _userdetails = Map<String, String>();
    _userdetails["Name"] = name;
    _userdetails['Token'] = token;
    _userdetails["email"] = _email;
    _userdetails["Date of birth"] = _dob;
    _userdetails["Phone Number"] = _phone_number;
    _userdetails["Pan/Aadhar Number"] = _pan;
    _userdetails["Role"] = _currentItem;
    _userdetails['display'] = null;
    await Firestore.instance.collection("User").document(_email).setData(
        _userdetails).whenComplete(() {
        print('Data pushed');
    });
  }catch(e){
    print(e);
  }
}

//Logging in with LinkedIn and pushing the details

Future addUserofGoogleandLinkedIn(String dob,String tok , String phone , String pan, String role) async {
  try {
    var _userdetails = Map<String, String>();
    _userdetails["Name"] = globals.name;
    _userdetails['Token'] = tok;
    _userdetails["email"] = globals.email;
    _userdetails["Date of birth"] = dob;
    _userdetails["Phone Number"] = phone;
    _userdetails["Pan/Aadhar Number"] = pan;
    _userdetails["Role"] = role;
    _userdetails['display'] = globals.Imageurl;
    await Firestore.instance.collection("User").document(globals.email).setData(
        _userdetails).whenComplete(() {
      print('Data pushed');
    });
  }catch(e){
    print(e);
  }
}

//Search for google and linkedin users if they are logging in for the first time or not

bool firstTime = false;

Future checkNewUser() async{
  try {
    DocumentSnapshot docSnap = await Firestore.instance.collection('User')
        .document(globals.email)
        .get();
    if (docSnap.exists) {
      firstTime = false;
    } else {
      firstTime = true;
    }
  }catch(e){
    print(e);
  }
}

// TO estabilish a chat room  between the poeple texting

String chatID;

estabilishConnection(String reciever , String recieverName , String recieverImageUrl) async{
  String user1;
  String user1Name;
  String user2;
  String user2Name;
  String user1display;
  String user2display;
  int check;
  check = globals.email.compareTo(reciever);
  if(check == 1){
    user2 = globals.email;
    user2Name = globals.name;
    user2display = globals.Imageurl;
    user1 = reciever;
    user1Name = recieverName;
    user1display = recieverImageUrl;
    chatID = '${globals.email}_${reciever}';
  }
  else if(check == -1){
    user1 = globals.email;
    user1Name = globals.name;
    user1display = globals.Imageurl;
    user2 = reciever;
    user2Name = recieverName;
    user2display = recieverImageUrl;
    chatID = '${reciever}_${globals.email}';
  }else{
  }
  var details ;
  details = Map<String , String>();
  details['chatRoomID'] = chatID;
  details['user1'] = user1;
  details['user2'] = user2;
  details['user1Name'] = user1Name;
  details['user2Name'] = user2Name;
  details['user1display'] = user1display;
  details['user2display'] = user2display;
  await Firestore.instance.collection('chatRoom').document(chatID).setData(details).whenComplete((){
    print('Chat room created ');
  });
}

//Method to add message in the database sent by the user

Future addMessagesoftheConvo(String chatRoomID,String sentTo , String message , String messageType) async{
  try {
    Map<String , dynamic>chatMessage = {
      "sentBy" : globals.email,
      "sentTo" : sentTo ,
      "message" : message,
      "time" : DateTime.now().toIso8601String(),
      "message type" : messageType
    };
    await Firestore.instance.collection('chatRoom').document(chatRoomID)
        .collection('chats').add(chatMessage)
        .whenComplete(() {
      print("Message added to the databse");
    });
  }catch(e){
    print(e);
  }
}

//Method to get the last text sent so as to display it on the front chat
Widget lastText(String chatRoomID){
  return StreamBuilder(
    stream: Firestore.instance.collection('chatRoom').document(chatRoomID).collection('chats')
        .orderBy('time',descending: true).limit(1).snapshots(),
    builder: (context , snapshot){
      return(!snapshot.hasData) ? SizedBox() : ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context , index){
          return (!snapshot.hasData) ? Text("") : Text(snapshot.data.documents[index].data['message'],
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
            fontSize: 14.0
          ),);
        },
      );
    },
  );
}

//Method to get the users on searching their name

Future searchByName(String name) async{
  return Firestore.instance.collection('User').where( 'Name' , isEqualTo: name).getDocuments();
}

//To estabilish a chatRoom for a group in the app

groupChatRoom ( String admin,String adminName, String groupName , String imageURL , List<User> selectedUsers , int lengthOfUsers ) async{
  var groupDetails;
  groupDetails = Map<String,String>();
  groupDetails['chatID'] = '${admin}_${groupName}';
  groupDetails['display'] = imageURL;
  groupDetails['NumberOfUsers'] = lengthOfUsers.toString();
  groupDetails['Admin'] = admin;
  groupDetails['AdminName'] = adminName;
  groupDetails['GroupName'] = groupName;
  int j = 0;
  for(int i= 0 ; i < selectedUsers.length ; i++){
    if(selectedUsers[i] == null){
    }
    else{
      groupDetails['User${j}Name'] = selectedUsers[i].name;
      groupDetails['User${j}email'] = selectedUsers[i].email;
      groupDetails['User${j}role'] = selectedUsers[i].role;
      j++;
    }
  }
  await Firestore.instance.collection('groupChats').document(admin+'_'+groupName).setData(groupDetails).whenComplete((){
    print('Group created');
    addGroupMessage("create" , '${admin}_${groupName}',
        "Created at ${DateFormat.jm().format(DateTime.parse(DateTime.now().toIso8601String()))}",
        "create");
  });
}

//Add message to group conversation

Future addGroupMessage(String origin , String chatRoomID , String message , String messageType) async{
  Map<String , dynamic> chatMessage = new Map();
  try {
    if(origin == "chat"){
      chatMessage = {
        "sentBy" : globals.name,
        "sentByemail" : globals.email,
        "message" : message,
        "time" : DateTime.now().toIso8601String(),
        "message type" : messageType
      };
    }else{
      chatMessage = {
        "sentBy" : "none",
        "sentByemail" : "none",
        "message" : message,
        "time" : DateTime.now().toIso8601String(),
        "message type" : messageType
      };
    }
    await Firestore.instance.collection('groupChats').document(chatRoomID)
        .collection('chats').add(chatMessage)
        .whenComplete(() {
      print("Message added to the database");
    });
  }catch(e){
    print(e);
  }
}

//Method to get the last text sent so as to display it on the front chat

Widget lastGroupText(String chatRoomID){
  return StreamBuilder(
    stream: Firestore.instance.collection('groupChats').document(chatRoomID).collection('chats')
        .orderBy('time',descending: true).limit(1).snapshots(),
    builder: (context , snapshot){
      return(!snapshot.hasData) ? SizedBox() : ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context , index){
          return (!snapshot.hasData) ? Text("") :  Row(
            children: <Widget>[
              (snapshot.data.documents[index].data['sentBy'] == 'none') ? Text("") :
              Text('${snapshot.data.documents[index].data['sentBy']} : ',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                    fontSize: 14.0
                ),),
              Flexible(
                child:
                (snapshot.data.documents[index].data['message type'] == 'image') ? Row(
                  children: <Widget>[
                    Icon(Icons.camera_alt , color: Colors.grey,size: 19.0,),
                    Text(" Image", style: TextStyle(
                      fontFamily: 'Poppins' , fontSize: 14.0,color: Colors.grey
                    ),),
                  ],
                ) : (snapshot.data.documents[index].data['message type'] == 'video') ? Row(
                  children: <Widget>[
                    Icon(Icons.videocam , color: Colors.grey,size: 19.0,),
                    Text(" Video", style: TextStyle(
                        fontFamily: 'Poppins' , fontSize: 14.0,color: Colors.grey
                    ),),
                  ],
                ) : (snapshot.data.documents[index].data['message type'] == 'file') ? Row(
                  children: <Widget>[
                    Icon(Icons.insert_drive_file , color: Colors.grey,size: 19.0,),
                    Text(" File", style: TextStyle(
                        fontFamily: 'Poppins' , fontSize: 14.0,color: Colors.grey
                    ),),
                  ],
                ) : Text(snapshot.data.documents[index].data['message'],
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      fontSize: 14.0
                  ),) ,
              ),
            ],
          );
        },
      );
    },
  );
}

//Method to get the time of last text sent on a chat
Widget lastTextTime(String chatRoomID){
  return StreamBuilder(
    stream: Firestore.instance.collection('chatRoom').document(chatRoomID).collection('chats')
        .orderBy('time',descending: true).limit(1).snapshots(),
    builder: (context , snapshot){
      return(!snapshot.hasData) ? SizedBox() : Container(
        child: Text("${DateFormat.jm().format(DateTime.parse((snapshot.data.documents[0].data['time'])))}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              color: Colors.black,
            ),),
      );
    },
  );
}

//Method to get the time of last text on a group
Widget lastGroupTextTime(String chatRoomID){
  return StreamBuilder(
    stream: Firestore.instance.collection('groupChats').document(chatRoomID).collection('chats')
        .orderBy('time',descending: true).limit(1).snapshots(),
    builder: (context , snapshot){
      return(!snapshot.hasData) ? SizedBox() : Container(
        child: ((snapshot.data.documents[0].data['time']) == null) ? Text("")
            :Text("${DateFormat.jm().format(DateTime.parse((snapshot.data.documents[0].data['time'])))}",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.black,
          ),),
      );
    },
  );
}


