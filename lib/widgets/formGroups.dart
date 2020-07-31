import 'package:alpinemessenger/screens/group_details.dart';
import 'package:alpinemessenger/widgets/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:alpinemessenger/models/userdata.dart';

class group extends StatefulWidget {
  @override
  _groupState createState() => _groupState();
}

class _groupState extends State<group> {

  List<User> selectedUsers = [];
  List<bool> boolUsers = new List<bool>();
  List<int> leng = [];
  bool selectingMode = false;
  int length = 0;
  bool isLoading = true;
  User user ;
  TextEditingController groupName = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeList();
  }

  selectUser(User user , int index){
    setState(() {
      selectedUsers[index] = user;
    });
    print(selectedUsers);
  }

  void makeList() async{
    try{
    await Firestore.instance.collection('User').getDocuments().then((doc){
       setState(() {
         isLoading = true;
         length = doc.documents.length;
       });
    });
    setState(() {
      for(int i=0;i<length;i++){
        boolUsers.add(false);
        selectedUsers.add(null);
      }
      isLoading = false;
    });
    print(boolUsers);
  }catch(e){
      print(e);
    }
  }

  void ItemChange(bool val,int index){
    setState(() {
      boolUsers[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue[800],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: (leng.length == 0) ? Column(
          children: <Widget>[
            Text( "New Group",style: TextStyle(
              fontFamily: 'Poppins',fontSize: 18.0
            ),overflow: TextOverflow.ellipsis,),
            Text("Select Participants",style: TextStyle(
                fontFamily: 'Poppins',fontSize: 14.0,color: Colors.white70
            ),overflow: TextOverflow.ellipsis,),
          ],
        ) :  Text( "${leng.length} User Selected ",style: TextStyle(
              fontFamily: 'Poppins',fontSize: 18.0
          ),overflow: TextOverflow.ellipsis,),
        centerTitle: true,
        leading: (leng.length == 0) ? IconButton(icon : Icon(Icons.arrow_back_ios),onPressed: (){
          Navigator.of(context).pop();
        },) : IconButton(icon : Icon(Icons.cancel),onPressed: (){
          setState(() {
            leng.clear();
            for(int j = 0; j < length ; j++ ){
              boolUsers[j] = false;
              selectedUsers[j] = null;
            }
            print(boolUsers);
            print(selectedUsers);
          });
        },) ,
        backgroundColor: Colors.blue[800],
        elevation: 0.0,
        actions: <Widget>[
          (leng.length == 0) ? SizedBox() : IconButton(icon : Icon(Icons.forward),onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => new group_details(selectedUsers, leng)
            ));
          },)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
          child: (isLoading) ? Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Colors.blue[800]),
            ),
          ): Padding(
            padding: EdgeInsets.only(top : 15.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection('User').snapshots(),
              builder: (context , snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:AlwaysStoppedAnimation<Color>(Colors.blue[800]),
                    ),
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context , index){
                       return(snapshot.data.documents[index].documentID == globals.email) ? Container() : Column(
                        children: <Widget>[
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal : 4.0 , vertical: 5.0),
                              child: CheckboxListTile(
                                value:(isLoading) ? false : boolUsers[index],
                                onChanged: (bool value){
                                  ItemChange(value, index);
                                  setState(() {
                                   if(value == true){
                                     var user = new User();
                                     user.isSelected = true;
                                     user.email = snapshot.data.documents[index].data['email'];
                                     user.name = snapshot.data.documents[index].data['Name'];
                                     user.role = snapshot.data.documents[index].data['Role'];
                                     selectUser(user , index);
                                     print(selectedUsers[index].name);
                                     leng.add(1);
                                   }else{
                                     user = null;
                                     selectUser(user , index);
                                     leng.removeLast();
                                   }
                                  });
                                  print(boolUsers);
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                secondary:FilterChip(
                                  backgroundColor: Colors.blue[200],disabledColor: Colors.blue[200],
                                  label: Text(snapshot.data.documents[index].data['Role'][0],style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),),
                                ) ,
                                title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ClipOval(
                                        child: CircleAvatar(
                                          child: Text(snapshot.data.documents[index].data['Name'][0]),
                                        ),
                                      ),
                                      SizedBox(width: 10.0,),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.documents[index].data['Name'],overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500, fontSize: 21),
                                            ),
                                            Text(snapshot.data.documents[index].data['email'],overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey,fontFamily: 'Poppins'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          )
                        ],
                      );
                    },
                  );
                }
              },
            )
          ),
        ),
      ),
    );
  }
}

