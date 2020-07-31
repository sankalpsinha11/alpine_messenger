import 'package:alpinemessenger/screens/display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class groupinfo extends StatefulWidget {
  final String groupID;
  groupinfo(this.groupID , {Key key}) : super(key : key);
  @override
  _groupinfoState createState() => _groupinfoState();
}

class _groupinfoState extends State<groupinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Group Info", style: TextStyle(
          color: Colors.white,fontFamily: 'Poppins',fontSize: 20.0
        ),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: StreamBuilder(
              stream: Firestore.instance.collection('groupChats').document(widget.groupID).snapshots(),
              builder: (context , snapshot){
                if(!snapshot.hasData){
                  return CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  );
                }else{
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 21.0,),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 95,
                          child: GestureDetector(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => new displayView(snapshot.data['display'])
                              ));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data['display']),
                              radius: 90.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Center(
                        child: Text(snapshot.data['GroupName'],textAlign: TextAlign.center,
                          style: TextStyle(
                          color: Colors.white,fontFamily: 'Poppins',fontSize: 40.0
                        ),),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('ADMIN :' , style: TextStyle(
                                  color: Colors.green,fontFamily: 'Poppins' , fontWeight: FontWeight.w700,fontSize: 16.0
                              ),),
                            ),
                            Column(
                              mainAxisAlignment : MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data['AdminName'] , style: TextStyle(
                                      color: Colors.black,fontFamily: 'Poppins' ,fontSize: 20.0, fontWeight: FontWeight.w400
                                  ),),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 30.0,),
                      Text('USERS' , style: TextStyle(
                          color: Colors.white,fontFamily: 'Poppins' , fontWeight: FontWeight.w500,fontSize: 24.0
                      ),),
                      SizedBox(height: 15.0,),
                      Container(
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: int.parse(snapshot.data['NumberOfUsers']),
                              itemBuilder: (context , index){
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0, bottom: 1.0, right: 7.0,left: 2.0),
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          CircleAvatar(
                                            //backgroundImage: AssetImage('assets/catdog.gif'),
                                            child: Text(snapshot.data['User${index}Name'][0] , style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins'
                                            ),),
                                            radius: 26.0,
                                            backgroundColor: Colors.blue[800],
                                          ),
                                          SizedBox(width: 15.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshot.data["User${index}Name"],style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500
                                              ),),
                                              SizedBox(height: 3.0,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width * 0.62,
                                                  child: Text(snapshot.data["User${index}email"],
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500
                                                  ),),
                                              ),
                                            ],
                                          ),
                                          FilterChip(
                                            label: Text(snapshot.data['User${index}role'][0], style: TextStyle(
                                              color: Colors.black
                                            ),),
                                            onSelected: (b){},
                                            backgroundColor: Colors.blue[200],
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(color: Colors.black,thickness: 0.17,)
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
