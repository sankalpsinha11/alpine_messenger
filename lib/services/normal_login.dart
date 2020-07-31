import 'package:flutter/material.dart';
import 'package:alpinemessenger/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//boolean for error in logging in
bool e = false;
Future<String> loginWithEmailandPwd(_email , _password , context) async {
  FirebaseUser user;
  try{
    user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email, password: _password)).user;
    e = false;
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => homepage('normal_login')
    ));
  }catch(err){
    e = true;
    print(err.toString());
  }
}

bool error = false;

Future sendResetLink(_email) async{
  try{
  await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
  error = false;
  print('No error');
  }catch(e){
    print(e);
    print('error');
    error = true;
  }
}