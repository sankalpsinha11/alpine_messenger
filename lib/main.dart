import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/loginpage.dart';
import 'package:alpinemessenger/screens/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[800],
      ),
      debugShowCheckedModeBanner: false,
      home: introPage(),
      routes: <String , WidgetBuilder>{
        '/landingpage' :(BuildContext context) => new MyApp(),
        '/loginpage' : (BuildContext context) => new login(),
      },
    );
  }
}

class introPage extends StatefulWidget {
  @override
  _introPageState createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            FadeAnimation(
              1 , Container(
                child: Image(
                  fit: BoxFit.cover,
                    image:AssetImage('assets/yo.jpg'),
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.4,
                  ),
                  FadeAnimation(
                    1.3 , SizedBox(
                      width: MediaQuery.of(context).size.width*0.87,
                      height: 50.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: Colors.blue[900],
                        elevation: 5.0,
                        splashColor: Colors.white,
                        child: Text("JOIN US !", style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => signup()),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.8,),
                  FadeAnimation(
                    1.5 , Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 29.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left :15.0 , right: 8.0),
                            child: Center(
                              child: Text("ALREADY JOINED ?  ", style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.23,
                          height: 30.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.blue[900],
                            elevation: 5.0,
                            splashColor: Colors.white,
                            child: Text("SIGN IN ", style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => login()
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}


