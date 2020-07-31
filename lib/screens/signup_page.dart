import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {

  var role = ['Client' , 'Employee'];
  String _currentItem ;
  bool _isTapped = false;
  bool red = false;
  final _formkey = GlobalKey<FormState>();
  bool _shwpwd = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _phone_number = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _pan = new TextEditingController();
  String t;
  final FirebaseMessaging m = new FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.getToken().then((tok){
      setState(() {
        t = tok;
      });
    });
  }


  void _shDialog(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
      image: Image.asset('assets/go.gif'),
      entryAnimation: EntryAnimation.TOP,
      title: Text("Here We Go!",style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700
      ),),
      description: Text("Welcome to Alpine! Login to continue.",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
        ),),
      onlyOkButton: true,
      onOkButtonPressed: (){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/loginpage');
      },
    )
    );
  }

  void _shDialog2(){
    showDialog(
        context: context,builder:(_)=> AssetGiffyDialog(
      image: Image.asset('assets/granny.gif'),
      entryAnimation: EntryAnimation.TOP,
      title: Text("Oops! Something went wrong.",style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700
      ),),
      description: Text("Either the email address is already in use or there is some other issue.",
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
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
            SizedBox(height: 80.0,),
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
                  SizedBox(height: 1.8,),
                  FadeAnimation(
                    1.3 , Text("Welcome to Alpine Technologies" , style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500
                    ),),
                  )
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
                          children: <Widget>[
                            SizedBox(height: 40.0,),
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
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person,color: (red) ? Colors.red : Colors.blue[700]),
                                            hintText: 'Enter Full Name',
                                            hintStyle: TextStyle(color: (red) ? Colors.red : Colors.grey,fontFamily: 'Poppins'),
                                            border: InputBorder.none
                                        ),
                                        controller: _name,
                                        validator: (value){
                                          if(value.isEmpty){
                                            setState(() {
                                              red = true;
                                            });
                                            return "Name not entered.";
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
                                        controller: _phone_number,
                                        validator: (value){
                                          if(value.isEmpty){
                                            setState(() {
                                              red = true;
                                            });
                                            return "Contact number not entered.";
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
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email,color: (red) ? Colors.red : Colors.blue[700]),
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
                                            return "Email address not entered.";
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
                                        controller: _dob,
                                        validator: (value){
                                          if(value.isEmpty){
                                            setState(() {
                                              red = true;
                                            });
                                            return "Date of birth not entered.";
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
                                            prefixIcon: Icon(Icons.recent_actors,color: (red) ? Colors.red : Colors.blue[700]),
                                            hintText: 'Enter PAN / Aadhar Card Number',
                                            hintStyle: TextStyle(color: (red) ? Colors.red : Colors.grey,fontFamily: 'Poppins'),
                                            border: InputBorder.none
                                        ),
                                        controller: _pan,
                                        validator: (value){
                                          if(value.isEmpty){
                                            setState(() {
                                              red = true;
                                            });
                                            return "PAN/AADHAR Card number not entered.";
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
                            SizedBox(height: 20.0,),
                            FadeAnimation(
                              1.7 , DropdownButton<String>(
                                hint: Text("SELECT YOUR ROLE", style: TextStyle(
                                  color: (red) ? Colors.red : Colors.grey,
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
                                  child: (_isTapped) ? SizedBox(
                                    height: 40.0,
                                    width: 100.0,
                                    child: SpinKitRipple(
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                  ): Text("SIGN UP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0
                                  ),),
                                  onPressed:  (!_isTapped) ? (){
                                    if(_formkey.currentState.validate()){
                                      setState(() {
                                        _isTapped = true;
                                      });
                                      adduser(_name.text, t ,_email.text ,_dob.text , _phone_number.text , _pan.text , _currentItem ).whenComplete((){
                                        signUpWithEmailAndPwd().whenComplete((){
                                          setState(() {
                                            _isTapped = false;
                                          });
                                        });
                                      });
                                    }
                                  } : null,
                                ),
                              ),
                            )
                          ],
                        ),
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

  Future<String> signUpWithEmailAndPwd() async {
    FirebaseUser user;
    try {user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text)).user;
    try {
      await user.sendEmailVerification();
      _shDialog();
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }}catch(e){
      _shDialog2();
      print(e);
    }
  }
}
