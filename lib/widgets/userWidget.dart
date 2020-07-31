import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          stream: Firestore.instance.collection('User').snapshots(),
          builder: (context , snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor:AlwaysStoppedAnimation<Color>(Colors.blue[800]),
                ),
              );
            }else{
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.documents.length ,
                itemBuilder: (context , index){
                  return FadeAnimation(
                    1.2 , Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                      borderRadius: BorderRadius.circular(14.0),
                      elevation: 5.0,
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0)
                        ),
                          child:(snapshot.data.documents[index].data['email'] == globals.email) ? null :  ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              (snapshot.data.documents[index].data['display'] == null) ? CircleAvatar(
                                child: Text('${snapshot.data.documents[index].data['Name'].toString().substring(0,1)}'),
                                radius: 26.0,
                              ) :CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data.documents[index].data['display']),
                                radius: 26.0,
                              ) ,
                              SizedBox(width: 23.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data.documents[index].data['Name'],style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500
                                  ),),
                                  SizedBox(height: 4.0,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.52,
                                    child: Text(
                                      snapshot.data.documents[index].data['email'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins'
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                            children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only( left : 16.0 , right: 16.0 , top:20.0 , bottom: 20.0),
                                  child: SizedBox(
                                    height: 45.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: RaisedButton(
                                      splashColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0)
                                      ),
                                      color: Colors.blue,
                                      child: Text("Message", style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 15.0
                                      ),),
                                      onPressed: (){
                                         estabilishConnection(snapshot.data.documents[index].data['email'] ,
                                             snapshot.data.documents[index].data['Name'] , snapshot.data.documents[index].data['display']).whenComplete((){
                                           Navigator.push(context, MaterialPageRoute(
                                               builder: (context) => new chatScreen(snapshot.data.documents[index].data['Name'].toString() ,
                                                   snapshot.data.documents[index].data['email'].toString()
                                                   , chatID , snapshot.data.documents[index].data['display'])
                                           ));
                                         });
                                      },
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only( left : 16.0 , right: 16.0 , top:0.0 , bottom: 30.0),
                                child: SizedBox(
                                  height: 45.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0)
                                    ),
                                    color: Colors.blue,
                                    child: Text("Video Call", style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 15.0
                                    ),),
                                    onPressed: (){},
                                  ),
                                ),
                              )
                            ],
                  ),
                        ),
                      ),
                    )
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
