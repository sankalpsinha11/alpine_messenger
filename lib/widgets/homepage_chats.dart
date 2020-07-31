import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;

class chatList extends StatefulWidget {
  @override
  _chatListState createState() => _chatListState();
}

class _chatListState extends State<chatList> {
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
            stream: Firestore.instance.collection('chatRoom').snapshots(),
            builder: (context , snapshot){
              return (!snapshot.hasData) ? SizedBox(
              ) : ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                String name;
                String Recieveremail;
                String display;
                //a bool variable to check whether whether you exist in the chatRoom or not
                bool iexist = true;
                if(snapshot.data.documents[index].data['user1'] == globals.email){
                  name = snapshot.data.documents[index].data['user2Name'];
                  Recieveremail = snapshot.data.documents[index].data['user2'];
                  display = snapshot.data.documents[index].data['user2display'];
                  iexist = true;
                }
                else if (snapshot.data.documents[index].data['user2'] == globals.email){
                  name = snapshot.data.documents[index].data['user1Name'];
                  Recieveremail = snapshot.data.documents[index].data['user1'];
                  display = snapshot.data.documents[index].data['user1display'];
                  iexist = true;
                }else{
                  iexist = false;
                }
                return FadeAnimation(
                  1.2 , Material(
                  elevation: 3.0,
                    color: Colors.white,
                    child:(iexist) ? InkWell(
                      onTap: (){
                        estabilishConnection(Recieveremail, name, display).whenComplete((){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => new chatScreen(name, Recieveremail , chatID , display)
                          ));
                        });
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
                            (display == null) ? CircleAvatar(
                              radius: 26,
                              foregroundColor: Colors.blue[800],
                              backgroundColor: Colors.blue[800],
                              child: Text(name[0],style: TextStyle(
                                  fontFamily: 'Poppins' , fontSize: 25.0 , color: Colors.white
                              ),),
                            ) : CircleAvatar(
                              radius: 26,
                              foregroundColor: Colors.blue[800],
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(display),
                            ),
                            SizedBox(width: 15.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(name,style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500
                                ),),
                                SizedBox(height: 3.0,),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.62,
                                  child: lastText(snapshot.data.documents[index].documentID)
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                    child: lastTextTime(snapshot.data.documents[index].documentID)),
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
