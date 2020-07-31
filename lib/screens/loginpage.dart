import 'dart:convert';
import 'package:alpinemessenger/screens/registration.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:alpinemessenger/services/google_sign_in.dart';
import 'package:alpinemessenger/services/linked_in_login.dart';
import 'package:alpinemessenger/services/normal_login.dart';
import 'package:linkedin_auth/linkedin_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/models/userdata.dart';
import 'package:alpinemessenger/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

String imageUrl;

class _loginState extends State<login> {

  bool _shwpwd = false;
  bool red = false;
  bool isLoggedIn = false;
  bool _isTapped = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();


  void _shDialog(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
          image: Image.asset('assets/mails.gif'),
          entryAnimation: EntryAnimation.TOP,
          title: Text("Go check your mailbox!",style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700
          ),),
          description: Text("Password Reset link has been sent!",
            style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),),
          onlyOkButton: true,
          onOkButtonPressed: (){
            Navigator.of(context).pop();
          },
        )
      );
  }

  void _shDialog2(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
          image: Image.asset('assets/granny.gif'),
          entryAnimation: EntryAnimation.TOP,
          title: Text("Oops! No username entered.",style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700
              ),),
          description: Text("Please enter your email address!",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),),
          onlyOkButton: true,
          onOkButtonPressed: (){
              Navigator.of(context).pop();
          },
        )
    );
  }

  void _shDialog3(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
      image: Image.asset('assets/granny.gif'),
      entryAnimation: EntryAnimation.TOP,
      title: Text("Oops! Something's wrong.",style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700
      ),),
      description: Text("The email you've entered is either wrong or doesn't exist.",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
        ),),
      onlyOkButton: true,
      onOkButtonPressed: (){
        Navigator.of(context).pop();
      },
    )
    );
  }


  void _shDialog4(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
      image: Image.asset('assets/granny.gif'),
      entryAnimation: EntryAnimation.TOP,
      title: Text("Oops! Something's wrong.",style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700
      ),),
      description: Text("Either the user doesn't exist or the credentials entered are incorrect.",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
        ),),
      onlyOkButton: true,
      onOkButtonPressed: (){
        Navigator.of(context).pop();
      },
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
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
            SizedBox(height: 80.0,),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1, Text("LOGIN", style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 40.0,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  SizedBox(height: 1.8,),
                  FadeAnimation(
                    1.3 , Text("WELCOME BACK", style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500
                    ),),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0) ,topRight: Radius.circular(60.0)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60.0,),
                        FadeAnimation(
                          1.4 , Container(
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
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person,color: (red) ? Colors.red : Colors.blue[700]),
                                          hintText: 'Enter Email Address',
                                          hintStyle: TextStyle(color: (red) ? Colors.red : Colors.grey,fontFamily: 'Poppins'),
                                          border: InputBorder.none
                                      ),
                                      controller: _email,
                                      validator: (value){
                                        if(value.isEmpty){
                                          setState(() {
                                            red = true;
                                          });
                                          return "Email not entered.";
                                        }else{
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.white))
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      obscureText: !_shwpwd,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock,color: (red) ? Colors.red : Colors.blue[700]),
                                          suffixIcon: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                _shwpwd =! _shwpwd;
                                              });
                                            },
                                            child: Icon(
                                                _shwpwd? Icons.visibility : Icons.visibility_off
                                            ),
                                          ),
                                          hintText: 'Enter Password',
                                          hintStyle: TextStyle(color: (red) ? Colors.red : Colors.grey,fontFamily: 'Poppins'),
                                          border: InputBorder.none
                                      ),
                                      controller: _password,
                                      validator: (value){
                                        if(value.isEmpty){
                                          setState(() {
                                            red = true;
                                          });
                                          return "Password not entered.";
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
                        ),
                        SizedBox(height: 10.0,),
                        FadeAnimation(
                          1.6, Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: InkWell(
                                focusColor: Colors.blue[800],
                                splashColor: Colors.blue[800],
                                onTap: (){
                                  if(_email.text.isNotEmpty){
                                    sendResetLink(_email.text).whenComplete((){
                                      if(error){
                                        _shDialog3();
                                      }else{
                                        _shDialog();
                                      }
                                    });
                                  }else{
                                      _shDialog2();
                                  }
                                },
                                child: Text("Forgot Password?" , style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0
                                ),),
                              ),
                            ),
                          ],
                        ),
                        ),
                        SizedBox(height: 35.0,),
                        FadeAnimation(
                          1.7 ,
                          SizedBox(
                             width: MediaQuery.of(context).size.width - 150,
                             height: 50.0,
                              child: RaisedButton(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                                ),
                                color: Colors.blue[800],
                                splashColor: Colors.white,
                                child: (_isTapped) ? Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: SpinKitRipple(
                                    color: Colors.white,
                                  ),
                                ): Text("SIGN IN" , style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0
                                ),),
                                disabledColor: Colors.blue[800],
                                onPressed: (!_isTapped) ? (){
                                  if(_formkey.currentState.validate()){
                                    setState(() {
                                      _isTapped = true;
                                    });
                                    getDetails(_email.text).whenComplete((){
                                      if(error_in_login){
                                        setState(() {
                                          _isTapped = false;
                                        });
                                        _shDialog4();
                                      }else{
                                      loginWithEmailandPwd(_email.text, _password.text, context).whenComplete((){
                                        if(e){
                                          setState(() {
                                            _isTapped = false;
                                          });
                                          _shDialog4();
                                        }
                                      });
                                      }
                                    });
                                  }
                              } : null,
                              )
                        ),
                        ),
                        SizedBox(height: 30,),
                        FadeAnimation(
                          1.8 , Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              ),
                              Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                  )),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Text(
                                "Continue Sign in with :",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.all(5.0)),
                              Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FadeAnimation(
                              1.7 ,
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.36,
                                height: 50.0,
                                child: SignInButton(
                                  Buttons.Google,
                                 text: "Google",
                                 padding: EdgeInsets.only(left : 20.0 ),
                                  onPressed: (){
                                    handleGoogleSignIn().whenComplete((){
                                      if(err){
                                        print("Error hai bc");
                                      }else{
                                        checkNewUser().whenComplete((){
                                          if(firstTime){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => new register('google')
                                            ));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => new homepage('google')
                                            ));
                                          }
                                        });
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black ,width: 0.03),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                )
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            FadeAnimation(
                              1.7 ,
                              SizedBox(
                                  width: MediaQuery.of(context).size.width*0.36,
                                  height: 50.0,
                                  child: SignInButton(
                                    Buttons.LinkedIn,
                                    text: "LinkedIn",
                                    padding: EdgeInsets.only(left : 12.0 ),
                                    onPressed: ()  {
                                      linkedinLogIn(context);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
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
