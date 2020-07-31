import 'package:alpinemessenger/screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;

class searchScreen extends StatefulWidget {
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {

  TextEditingController searchUser = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot searchSnapshot;
  bool haveUserSearched = false;

  initiateSearch() async{
    if(searchUser.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await searchByName(searchUser.text).then((snapshot){
        searchSnapshot = snapshot;
        print('$searchSnapshot');
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget ListOfUsers(){
    return (haveUserSearched) ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal : 5.0 ),
          child: Material(
            borderRadius: BorderRadius.circular(14.0),
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0)
              ),
              child: (searchSnapshot.documents[index].data['email'] == globals.email) ? null :  ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (searchSnapshot.documents[index].data['display'] == null) ?
                CircleAvatar(
                 child: Text(searchSnapshot.documents[index].data['Name'][0]),
                  radius: 26.0,
                ) :CircleAvatar(
                      backgroundImage: NetworkImage(searchSnapshot.documents[index].data['display']),
                      radius: 26.0,
                    ),
                    SizedBox(width: 23.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(searchSnapshot.documents[index].data['Name'],style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500
                        ),),
                        SizedBox(height: 4.0,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: Text(
                            searchSnapshot.documents[index].data['email'],
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
                          estabilishConnection(searchSnapshot.documents[index].data['email'] , searchSnapshot.documents[index].data['Name']
                            , searchSnapshot.documents[index].data['display']).whenComplete((){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => new chatScreen(searchSnapshot.documents[index].data['Name'].toString(),
                                    searchSnapshot.documents[index].data['email'].toString(),
                                    chatID , searchSnapshot.documents[index].data['display'])
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
        );
      },
    ) : Container();
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only( top : 28.0 , left: 30.0 , right: 30.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0)
                            ),
                          ),
                          enabled: true,
                          hintText: 'Search by Name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          )
                        ),
                        controller: searchUser,
                      ),
                      SizedBox(height: 15.0,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: RaisedButton(
                          splashColor: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)
                          ),
                          onPressed: (){
                            initiateSearch().whenComplete((){
                              print("Searched name ${searchUser.text}");
                            });
                          },
                          color: Colors.blue[800],
                          child:(isLoading) ? SizedBox(
                            child: SpinKitRipple(
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ) :Text('Search' , style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins'
                          ),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListOfUsers()
            ],
          ),
        ),
      ),
    );
  }
}
