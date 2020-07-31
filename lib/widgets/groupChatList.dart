import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:alpinemessenger/screens/groupChat.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;


class groupchatList extends StatefulWidget {
  @override
  _groupchatListState createState() => _groupchatListState();
}

class _groupchatListState extends State<groupchatList> {

  bool iexist = true;
  List<String> participants = [];
  //a function to check whether the user is the group or not
  Future usersExisiting(DocumentSnapshot doc) async{
    try {
      for (int i = 0; i < int.parse(doc['NumberOfUsers']); i++) {
        if (doc['User${i}email'] == globals.email) {
          setState(() {
            iexist = true;
          });
          break;
        } else if (doc['Admin'] == globals.email) {
          setState(() {
            iexist = true;
          });
          break;
        }
        else {
          setState(() {
            iexist = false;
          });
        }
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: StreamBuilder(
            stream: Firestore.instance.collection('groupChats').snapshots(),
            builder: (context , snapshot){
              return (!snapshot.hasData) ? SizedBox() : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  for (int i = 0; i < int.parse(snapshot.data.documents[index].data['NumberOfUsers']); i++) {
                    if (snapshot.data.documents[index].data['User${i}email'] == globals.email) {
                      iexist = true;
                      break;
                    } else if (snapshot.data.documents[index].data['Admin'] == globals.email) {
                      iexist = true;
                      break;
                    }
                    else {
                        iexist = false;
                    }
                  }
                  return FadeAnimation(
                    1.2 , Material(
                    elevation: 3.0,
                    color: Colors.white,
                    child:(iexist) ? InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => new groupChat(snapshot.data.documents[index].data['GroupName'],
                                snapshot.data.documents[index].documentID, snapshot.data.documents[index].data['display'])
                        ));
                      },
                      splashColor: Colors.blue[800],
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 1.0, right: 7.0,left: 2.0),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:(snapshot.data.documents[index].data['display'] == null) ? null : NetworkImage(snapshot.data.documents[index].data['display']),
                              radius: 26.0,
                            ),
                            SizedBox(width: 15.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data.documents[index].data['GroupName'],style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500
                                ),),
                                SizedBox(height: 3.0,),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.62,
                                  child: lastGroupText(snapshot.data.documents[index].documentID,),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: lastGroupTextTime(snapshot.data.documents[index].documentID)
                                ),
                                SizedBox(height: 12.0,),
                                Text('NEW' , style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400
                                ),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ) : null,
                  ),
                  );
                },
              );
            }
        ),
      ),
    );
  }
}