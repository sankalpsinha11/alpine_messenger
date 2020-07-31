import 'dart:io';
import 'package:alpinemessenger/Animation/FadeAnimation.dart';
import 'package:alpinemessenger/screens/display.dart';
import 'package:alpinemessenger/screens/groupAttachments.dart';
import 'package:alpinemessenger/screens/groupInfo.dart';
import 'package:alpinemessenger/screens/homepage.dart';
import 'package:alpinemessenger/services/firestore_methods.dart';
import 'package:alpinemessenger/widgets/attachFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class groupChat extends StatefulWidget {
  final String groupname;
  String chatRoomId;
  String imageURL;
  groupChat(this.groupname, this.chatRoomId, this.imageURL , {Key key}) : super(key: key);
  @override
  _groupChatState createState() => _groupChatState();
}

bool isTap = false;

class _groupChatState extends State<groupChat> {

  final TextEditingController _messageController = new TextEditingController();

  File file;

  Future getFile(FileType fileType) async {
    var tempfile = await FilePicker.getFile(type: fileType);
    setState(() {
      file = tempfile;
    });
    (file == null) ? print("Empty") : print("got it here");
  }

  Future uploadFile(File file , String messageType)  async{
    StorageReference ref = FirebaseStorage.instance.ref().child('${widget.chatRoomId}/${globals.email}_${DateTime.now().toIso8601String()}');
    StorageTaskSnapshot storageTaskSnapshot;
    await ref.putFile(file).onComplete.then((value){
      if(value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadURL){
          addGroupMessage("chat",widget.chatRoomId, downloadURL, messageType);
        });
      }else{
        showToast('No file sent.' ,
            context:  context,
            borderRadius: BorderRadius.circular(10.0),
            animation: StyledToastAnimation.fade,
            backgroundColor: Colors.blue[400],
            position: StyledToastPosition.center,
            alignment: Alignment.center
        );
      }
    });
  }


  Widget getMessages(){
    return StreamBuilder(
      stream: Firestore.instance.collection('groupChats').document(widget.chatRoomId).collection('chats').orderBy('time',descending: true).snapshots(),
      builder: (context , snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context , index){
              return ChatMessage(
                text: snapshot.data.documents[index].data['message'],
                sentByMe: (globals.email == snapshot.data.documents[index].data['sentByemail']) ? true : false,
                time: snapshot.data.documents[index].data['time'],
                messageType: snapshot.data.documents[index].data['message type'],
                senderName: snapshot.data.documents[index].data['sentBy'],
              );
            },
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget _textComposerWidget(){
    return  Container(
      height: 70.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            iconSize: 25.0,
            color: Colors.blue[800],
            onPressed: (){
              final act = CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: Text('Send Image'),
                      onPressed: () {
                        getFile(FileType.image).whenComplete(() {
                          Navigator.of(context).pop();
                          if(file == null) {
                            showToast('No file selected.' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                          else{
                            try{
                              uploadFile(file , 'image').whenComplete((){
                                print("Uploaded");
                              });}catch(e){
                              print(e);
                            }
                            showToast('Sending...' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                        });
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text('Send Video',),
                      onPressed: () {
                        getFile
                          (FileType.video).whenComplete(() {
                          Navigator.of(context).pop();
                          if(file == null) {
                            showToast('No file selected.' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                          else{
                            try{
                              uploadFile(file , 'video').whenComplete((){
                                print("Uploaded");
                              });}catch(e){
                              print(e);
                            }
                            showToast('Sending...' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                        });
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text('Send File'),
                      onPressed: () {
                        getFile
                          (FileType.any).whenComplete(() {
                          Navigator.of(context).pop();
                          if(file == null) {
                            showToast('No file selected.' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                          else{
                            try{
                              uploadFile(file , 'file').whenComplete((){
                                print("Uploaded");
                              });}catch(e){
                              print(e);
                            }
                            showToast('Sending...' ,
                                context:  context,
                                borderRadius: BorderRadius.circular(10.0),
                                animation: StyledToastAnimation.fade,
                                backgroundColor: Colors.blue[400],
                                position: StyledToastPosition.center,
                                alignment: Alignment.center
                            );
                          }
                        });
                      },
                    )
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ));
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => act);
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Colors.blue[400] , fontFamily: 'Poppins')
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.blue[800],
            onPressed: (){
              if(_messageController.text.isEmpty){
                return null;
              }else{
                addGroupMessage("chat",widget.chatRoomId , _messageController.text , 'text');
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.blue[800],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: FadeAnimation(
            1.1 , AppBar(
            centerTitle: true,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => new groupAttachments(widget.chatRoomId)
                  ));
                },
                contentPadding: EdgeInsets.all(0.0),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.imageURL),
                ),
                title: Text(widget.groupname,style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontFamily: 'Poppins'
                ),overflow: TextOverflow.ellipsis,
                ),
                dense: true,
              ),
            ),
            leading:Padding(
              padding:  EdgeInsets.only(top : 13.0),
              child: IconButton(
                icon :  Icon(Icons.arrow_back_ios) ,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(top :8.0 , right: 18.0),
                child: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> new groupinfo(widget.chatRoomId)));
                    },
                    icon : Icon(Icons.people_outline, color: Colors.white,size: 30.0,)),
              ) ,
            ],
          ),
          ),
        ),
        body: Container(
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
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: ()=> FocusScope.of(context).unfocus(),
                        child: Column(
                          children: <Widget>[
                            new Flexible(
                                child: FadeAnimation(1.3 , getMessages())
                            ),
                            new Divider(
                              height: 1.0,
                            ),
                            FadeAnimation(
                              1.5 , new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white38
                              ),
                              child: _textComposerWidget(),
                            ),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String pathPDF = "";

class ChatMessage extends StatelessWidget {
  final String _name = globals.name;
  final String text ;
  final String time;
  final String senderName;
  bool sentByMe ;
  final String messageType;
  ChatMessage({this.text , this.sentByMe , this.time , this.senderName , this.messageType});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment:(messageType == 'create') ? Alignment.center : ((sentByMe) ? Alignment.centerRight : Alignment.centerLeft),
        margin:(messageType == 'create') ? EdgeInsets.all(0.0) :((sentByMe) ? EdgeInsets.only(top: 8.0 , bottom: 10.0 , left: 90.0 , right: 5.0)
            :  EdgeInsets.only(top: 8.0 , bottom: 10.0 , left: 5.0 , right: 90.0)) ,
        child:  (messageType == 'create') ? Center(
          child: FilterChip(
            label: Text(text , style: TextStyle(
              fontFamily: 'Poppins'
            ),),
          ),
        ) : (messageType == 'text') ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                child: new Container(
                    decoration: BoxDecoration(
                        color: (sentByMe) ?  Colors.blue[400] : Colors.blue[200],
                        borderRadius: (sentByMe) ? BorderRadius.only(topRight: Radius.circular(25.0) ,
                            bottomLeft: Radius.circular(25.0) , topLeft: Radius.circular(25.0) ):
                        BorderRadius.only(topRight: Radius.circular(25.0) ,
                            bottomRight: Radius.circular(25.0) , topLeft: Radius.circular(25.0) )
                    ),
                    margin: EdgeInsets.only(top: 5.0),
                    child:Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          (sentByMe) ? SizedBox(): Text(senderName , style: TextStyle(
                            color : Colors.blueGrey[800],fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 17.0
                          ),),
                          Container(
                            padding: (sentByMe) ? EdgeInsets.only(top : 0) : EdgeInsets.only(top : 3.5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: new Text(text,
                                    textAlign: TextAlign.start,style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15
                                    ),),
                                ) ,
                                (messageType == 'text') ? SizedBox(width : 17.0) : SizedBox(),
                                Text(time.substring(11 ,16 ),style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 12.0
                                )),

                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ]) : (messageType == 'image') ? imageFile(text , sentByMe , time)
            : (messageType == 'file') ? Column(
          crossAxisAlignment: (sentByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
          width: 150.0,
          height: 150.0,
          child:Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25.0) , topLeft: Radius.circular(25.0) )
                      ),
                      width: 150.0,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(Icons.insert_drive_file , color: Colors.blue, size: 30.0,),
                          Text('FILE' , style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 20.0
                          ),)
                        ],
                      )
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0) , bottomRight : Radius.circular(25.0) )
                    ),
                    child: Center(
                      child:  IconButton(icon: Icon(Icons.file_download),
                          splashColor: Colors.white,
                          onPressed: (){
                        print(text);
                            downloadFile(text);
                        showToast('Downloading...' ,
                            context:  context,
                            borderRadius: BorderRadius.circular(10.0),
                            animation: StyledToastAnimation.fade,
                            backgroundColor: Colors.blue[400],
                            position: StyledToastPosition.center,
                            alignment: Alignment.center
                        );
                          }) ,
                    ),
                  ),
                ],
          ),

        ),
                Text('${DateFormat.yMMMEd().format(DateTime.parse(time))}',style: TextStyle(
                    fontSize: 15.0 , fontFamily: 'Poppins', color: Colors.blue[800]
                ),)
              ],
            ) : Column(
          crossAxisAlignment: (sentByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
          width: 150.0,
          height: 150.0,
          child:Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25.0) , topLeft: Radius.circular(25.0) )
                      ),
                      width: 150.0,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(Icons.videocam , color: Colors.blue, size: 30.0,),
                          Text('VIDEO' , style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 20.0
                          ),)
                        ],
                      )
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0) , bottomRight : Radius.circular(25.0) )
                    ),
                    child: Center(
                      child:  IconButton(icon: Icon(Icons.play_arrow),
                          splashColor: Colors.white,
                          onPressed: (){
                            showDialog(
                                context: context ,
                                builder: (BuildContext context){
                                  return VideoPlayerWidget(text);
                                }
                            );
                          }) ,
                    ),
                  ),
                ],
          ),
        ),SizedBox(height: 4.0,),
                Text('${DateFormat.yMMMEd().format(DateTime.parse(time))}',style: TextStyle(
                    fontSize: 15.0 , fontFamily: 'Poppins', color: Colors.blue[800]
                ),)
              ],
            )
    );
  }
}

//Stateless widget of an image displayer in flutter

class imageFile extends StatelessWidget {
  final String text;
  bool sentByMe;
  final String time;
  imageFile(this.text , this.sentByMe , this.time);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: (sentByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => new displayView(text)
            ));
          },
          child: Container(
              decoration: BoxDecoration(
                  color: (sentByMe) ?  Colors.blue[400] : Colors.blue[200],
                  borderRadius: (sentByMe) ? BorderRadius.only(topRight: Radius.circular(25.0) ,
                      bottomLeft: Radius.circular(25.0) , topLeft: Radius.circular(25.0) ):
                  BorderRadius.only(topRight: Radius.circular(25.0) ,
                      bottomRight: Radius.circular(25.0) , topLeft: Radius.circular(25.0) )
              ),
              margin: EdgeInsets.only(top: 5.0),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image(
                        image: NetworkImage(text), width: 150.0 , height: 180.0,),

              )),
        ),
        SizedBox(height:4.0),
        Text('${DateFormat.yMMMEd().format(DateTime.parse(time))}',style: TextStyle(
          fontSize: 15.0 , fontFamily: 'Poppins', color: Colors.blue[800]
        ),)
      ],
    );
  }
}

downloadFile(String fileUrl) async {
  final Directory downloadsDirectory = await getExternalStorageDirectory();
  final String downloadsPath = downloadsDirectory.path;
  print(downloadsDirectory);
  print(downloadsPath);
  await FlutterDownloader.enqueue(
    url: fileUrl,
    savedDir: downloadsPath,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  ).then((id){
    FlutterDownloader.open(taskId: id).whenComplete((){
      print("ok");
    });
  });
}


class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(videoUrl);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  double videoDuration = 0;
  double currentDuration = 0;
  _VideoPlayerWidgetState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();
      });

    });

    videoPlayerController.addListener(() {
      setState(() {
        currentDuration = videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
    print(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()=> Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            color: Color(0xFF737373),
            // This line set the transparent background
            child: Container(
                color: Colors.blue[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      constraints: BoxConstraints(maxHeight: 400),
                      child: videoPlayerController.value.initialized
                          ? AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      )
                          : Container(
                        height: 200,
                        color: Colors.black,
                      ),
                    ),
                    Slider(
                      value: currentDuration,
                      max: videoDuration,
                      onChanged: (value) => videoPlayerController
                          .seekTo(Duration(milliseconds: value.toInt())),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:24.0),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                            child: Icon(
                              videoPlayerController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40.0,),
                            onTap: () {
                              setState(() {
                                videoPlayerController.value.isPlaying
                                    ? videoPlayerController.pause()
                                    : videoPlayerController.play();
                              });
                            }),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}

