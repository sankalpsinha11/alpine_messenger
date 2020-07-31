import 'dart:ui';
import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/models/userdata.dart';
import 'package:alpinemessenger/screens/loginpage.dart';
import 'package:alpinemessenger/screens/search_user_screen.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:alpinemessenger/services/linked_in_login.dart';
import 'package:alpinemessenger/widgets/formGroups.dart';
import 'package:alpinemessenger/widgets/groupChatList.dart';
import 'package:alpinemessenger/widgets/homepage_chats.dart';
import 'package:alpinemessenger/widgets/profile_screen.dart';
import 'package:alpinemessenger/widgets/userWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/services/google_sign_in.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;

class homepage extends StatefulWidget {

  final String button;
  homepage(this.button , {Key key}) : super(key : key);
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  int selectedIndex = 0;
  List<String> options = ['Chats' , 'Groups' ,  'Profile' , 'Search' , 'Users'];

  void initState(){
    super.initState();
    getDetails(globals.email).whenComplete((){
      print(globals.email);
      print(widget.button);
    });
  }

  _shDialog(){
    return showDialog(
      context: context,
      builder: (_)=>BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          elevation: 10.0,backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                  color: Colors.blue[800],
                  width: 4.0
              )
          ),
          child: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width*0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 45.0,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)
                    ),
                    onPressed: (){

                    },
                    child: Text('Individual Message',style: TextStyle(
                      fontFamily: 'Poppins',color: Colors.white
                    ),),
                    color: Colors.blue[800],
                    splashColor: Colors.white,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    ),
                    Expanded(
                        child: Divider(
                          color: Colors.blue[800],
                        )),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                          fontSize: 20.0,fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Expanded(
                        child: Divider(
                          color: Colors.blue[800],
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45.0,
                  child: MaterialButton(

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)
                    ),
                    onPressed: (){

                    },
                    child: Text('Group Message',style: TextStyle(
                        fontFamily: 'Poppins',color: Colors.white
                    ),),
                    color: Colors.blue[800],
                    splashColor: Colors.white,
                  ),
                )

              ],
            ),
          ),
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return null;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          padding: EdgeInsets.only(top: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue[900],
                    Colors.blue[700],
                    Colors.blue[300]
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height : 20.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FadeAnimation(1.1 , Padding(
                        padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        child:(globals.Imageurl == null) ? CircleAvatar(
                          radius: 18.0,
                          foregroundColor: Colors.blue[800],
                          backgroundColor: Colors.white,
                          child: Text(globals.name[0],style: TextStyle(
                              fontFamily: 'Poppins' , fontSize: 20.0 , color: Colors.blue[800]
                          ),),
                        ) : CircleAvatar(
                          radius: 20.0,
                          foregroundColor: Colors.blue[800],
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(globals.Imageurl),
                        ),
                      ),
                    )),
                    FadeAnimation(
                      1.1 , Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Text("alpine",style: TextStyle(
                              color: Colors.blue[200],
                              fontSize: 20.0,
                              fontFamily: 'Poppins'
                            ),),
                            Text("messenger",style: TextStyle(
                                color: Colors.red[300],
                                fontSize: 20.0,
                                fontFamily: 'Poppins'
                            ),),
                          ],
                        ),
                      ),
                    ),
                    FadeAnimation(
                      1.1 , IconButton(
                          icon: Icon(Icons.people),
                          iconSize: 30.0,
                          color: Colors.white,
                          padding: EdgeInsets.all(15.0),
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => group()
                            ));
                          }
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Expanded(
                flex: 1,
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: options.length,
                      itemBuilder: (context , index){
                        return FadeAnimation(
                          1.3 , GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical : 10.0 , horizontal: 25.0 ),
                              child: Text(options[index] , style: TextStyle(
                                color: (index == selectedIndex) ? Colors.white : Colors.white60,
                                fontFamily: 'Poppins',
                                fontSize: 20.0
                              ),),
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ),
              Expanded(
                flex: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60.0),
                        topLeft: Radius.circular(60.0)
                      )
                    ),
                    child:  (selectedIndex == 0 ) ? chatList() : (selectedIndex ==1) ? groupchatList() :
                    (selectedIndex == 2) ? profile(widget.button) :(selectedIndex == 3) ? searchScreen(): UsersList()
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}
