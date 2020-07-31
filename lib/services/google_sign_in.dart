import 'package:alpinemessenger/models/userdata.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';


bool err = false;

//instances of firebase auth and google auth
final GoogleSignIn _googleSignIn = new GoogleSignIn(scopes:['email']);
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _user;

//Google Sign in method
Future<void> handleGoogleSignIn() async {
  try {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _auth.signInWithCredential(
        credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);
    globals.name = user.displayName;
    globals.email = user.email;
    globals.Imageurl = user.photoUrl;
    err = false;
  }catch(e){
    print(e);
    err = true;
  }
}

 signOutGoogle() async{
  await _googleSignIn.signOut();
  print('google signed out');
}