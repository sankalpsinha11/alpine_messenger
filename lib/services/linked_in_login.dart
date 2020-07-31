
import 'package:alpinemessenger/models/userdata.dart';
import 'package:alpinemessenger/screens/homepage.dart';
import 'package:alpinemessenger/screens/registration.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:linkedin_auth/linkedin_auth.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;


//Linked In requirements for OAuth authentication
final String redirectUrl = 'https://www.alpine_messenger.com/auth/linkedin/callback/homepage';
final String clientId = '868qh8y61vvy0p';
final String clientSecret = 'vKGGaopuJ4I0YHvO';

bool logOutLinkedIn = false;

//Linked Log in method
linkedinLogIn( BuildContext context) {
  Navigator.push(  context , MaterialPageRoute(
      builder: (BuildContext context) => LinkedInUserWidget(
        destroySession: logOutLinkedIn,
        redirectUrl: redirectUrl,
        clientId: clientId,
        clientSecret: clientSecret,
        onGetUserProfile: (LinkedInUserModel linkedInUser) {
          print('Access token ${linkedInUser.token.accessToken}');
          print('User id: ${linkedInUser.userId}');
          globals.name = linkedInUser.firstName.localized.label + " " + linkedInUser.lastName.localized.label;
          globals.email = linkedInUser.email.elements[0].handleDeep.emailAddress;
          globals.Imageurl = null;
          checkNewUser().whenComplete((){
            Navigator.of(context).pop();
            if(firstTime){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => register('linkedin')));
            }
            else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => homepage('linkedin')));
            }
          });
          },
        catchError: (LinkedInErrorObject error) {
          print('Error description: ${error.description},'
              ' Error code: ${error.statusCode.toString()}');
          Navigator.pop(context);
        },

      ),
      fullscreenDialog: true,
    ),
  );
}
