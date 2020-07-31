import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;

class register extends StatefulWidget {
  final String button;
  register(this.button , {Key key}): super(key : key);
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {

  final _formkey = GlobalKey<FormState>();
  var role = ['Client' , 'Employee'];
  String _currentItem ;
  bool isT = false;
  bool isTapped = false;
  bool red = false;
  TextEditingController phone = new TextEditingController();
  TextEditingController dob = new TextEditingController();
  TextEditingController pan = new TextEditingController();
  String token;
  final FirebaseMessaging message = new FirebaseMessaging();

  void initState(){
    super.initState();
    isT = false;
    message.getToken().then((t){
      setState(() {
        token = t;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 18.0),
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
            SizedBox(height: 70.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1, Text("REGISTER", style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500
                  ),),
                  ),
                  SizedBox(height: .5,),
                  FadeAnimation(
                    1.3 , Text("Welcome to Alpine Technologies" , style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500
                  ),),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0) ,topRight: Radius.circular(60.0)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: FadeAnimation(
                      1.5 , Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 110.0,
                          width: 110.0,
                          child:(globals.Imageurl == null) ? CircleAvatar(
                            foregroundColor: Colors.blue[800],
                            backgroundColor: Colors.blue[800],
                            child: Text(globals.name[0],style: TextStyle(
                              fontFamily: 'Poppins' , fontSize: 40.0 , color: Colors.white
                            ),),
                          ) : CircleAvatar(
                            foregroundColor: Colors.blue[800],
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(globals.Imageurl),
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text("Hey There, ${globals.name}!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),),
                        SizedBox(height: 2.0,),
                        Center(
                          child: Text("Since you're logging in for the first time, Please fill the following necessary details. Thanks!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                            color: Colors.blue[800],
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 15.0,
                          ),),
                        ),
                        SizedBox(height: 25.0,),
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
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone,color: (red) ? Colors.red : Colors.blue[700]),
                                        hintText: 'Enter Phone Number',
                                        hintStyle: TextStyle(
                                            color: (red) ? Colors.red : Colors.grey,
                                            fontFamily: 'Poppins'
                                        ),
                                        border: InputBorder.none
                                    ),
                                    controller: phone,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your contact number.";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_today , color: (red) ? Colors.red : Colors.blue[700]),
                                        hintText: 'Enter Date Of Birth',
                                        hintStyle: TextStyle(color: (red) ? Colors.red : Colors.grey,fontFamily: 'Poppins'),
                                        border: InputBorder.none
                                    ),
                                    controller: dob,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your Date of Birth.";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.white))
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.recent_actors,color:(red) ? Colors.red :Colors.blue[700]),
                                        hintText: 'Enter PAN / Aadhar Card Number',
                                        hintStyle: TextStyle(color: (red) ? Colors.red :Colors.grey,fontFamily: 'Poppins'),
                                        border: InputBorder.none
                                    ),
                                    controller: pan,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your PAN/AADHAR card number.";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        FadeAnimation(
                          1.7 , DropdownButton<String>(
                          hint: Text("SELECT YOUR ROLE", style: TextStyle(
                              color: (red) ? Colors.red :Colors.grey,
                              fontFamily: 'Poppins',
                              fontSize: 15.0
                          ),),
                          items: role.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value,style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0
                              )),
                            );
                          }).toList(),
                          onChanged: (ok) {
                            setState(() {
                              _currentItem = ok;
                            });
                          },
                          value: _currentItem,
                        ),
                        ),
                        SizedBox(height: 25.0,),
                        FadeAnimation(
                          1.9 , SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          height: 50.0,
                          child: RaisedButton(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.blue[800],
                            splashColor: Colors.white,
                            disabledColor: Colors.blue[800],
                            child:(isTapped) ? SizedBox(
                              height: 40.0,
                              width: 100.0,
                              child: SpinKitRipple(
                                size: 50.0,
                                color: Colors.white,
                              ),
                            ): Text("LETS GO!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0
                              ),),
                            onPressed:(!isT) ? (){
                              if(_formkey.currentState.validate()){
                                setState(() {
                                  isT = true;
                                  isTapped = true;
                                });
                                addUserofGoogleandLinkedIn(dob.text, token , phone.text , pan.text , _currentItem).whenComplete((){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=> new homepage(widget.button)
                                  ));
                                });
                              }else{
                                setState(() {
                                  red = true;
                                });
                              }
                            } : null
                          ),
                        ),
                        )
                      ],
                    )
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
