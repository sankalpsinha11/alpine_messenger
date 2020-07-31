import 'dart:io';
import 'dart:ui';
import 'package:alpinemessenger/models/globals.dart' as globals;
import 'package:alpinemessenger/screens/display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class chatInfo extends StatefulWidget {
  String ID;
  chatInfo(this.ID , {Key key}) : super(key:key);
  @override
  _chatInfoState createState() => _chatInfoState();
}

class _chatInfoState extends State<chatInfo> with SingleTickerProviderStateMixin {

  TabController tabController;
  File file;
  bool isLoading = true;
  String name;


  downloadFile(String fileUrl) async {
    FlutterDownloader.initialize();
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

  Future getDetails(String chatID) async{
    await Firestore.instance.collection('chatRoom').document(chatID).get().then((val){
      if(globals.email == val.data['user1']){
        setState(() {
          name = val.data['user2Name'];
        });
      }else{
        setState(() {
          name = val.data['user1Name'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails(widget.ID).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text((isLoading) ? "" : name, style: TextStyle(
          fontFamily: 'Poppins', color: Colors.blue,
        ),),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), color: Colors.blue,
            onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body:(isLoading) ? Center(child: CircularProgressIndicator()) : Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: CircleAvatar(
                radius: 50.0,
                child: CircleAvatar(
                  radius: 45.0,
                  child: Text(name[0],style: TextStyle(
                    fontFamily: 'Poppins',fontSize: 40.0
                  ),),
                ),
              ),
            ),
            SizedBox(height: 40.0,),
            Text("Attachments",style: TextStyle(
              fontFamily: 'Poppins', fontSize: 32.0 , color: Colors.blue[800],fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 20.0,),
            Container(
              color: Colors.transparent,
              child: new TabBar(
                unselectedLabelColor: Colors.black,
                controller: tabController,
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontFamily: "Poppins" , fontSize: 16.0,color: Colors.blue[800]),
                unselectedLabelStyle: TextStyle(fontFamily: "Poppins" , fontSize: 16.0,color: Colors.black),
                tabs: [
                  new Tab(
                    icon: const Icon(Icons.image ,size: 30.0,),
                    text: ("Images"),
                  ),
                  new Tab(
                    icon: const Icon(Icons.videocam ,),
                    text: ("Videos"),
                  ),
                  new Tab(
                    icon: const Icon(Icons.insert_drive_file,),
                    text: ("Files"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: new TabBarView(
                  controller: tabController,
                  children: <Widget>[
                     new Container(
                        child: StreamBuilder(
                          stream: Firestore.instance.collection("chatRoom").
                          document(widget.ID).collection("chats").where('message type',isEqualTo: "image").
                          orderBy('time',descending:true).snapshots(),
                          builder: (context , snapshot){
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }else{
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context , index){
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical : 1.0 , horizontal: 1.2),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => new displayView(snapshot.data.documents[index].data['message'])
                                        ));
                                      },
                                      child: Image(
                                        image: NetworkImage("${snapshot.data.documents[index].data['message']}"),
                                        fit: BoxFit.cover,
                                      )
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        )
                      ),
                    new Container(
                        child: StreamBuilder(
                          stream: Firestore.instance.collection("chatRoom").
                          document(widget.ID).collection("chats").where('message type',isEqualTo: "video").
                          orderBy('time',descending:true).snapshots(),
                          builder: (context , snapshot){
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }else{
                              return ListView.separated( // show the list of files
                                padding: EdgeInsets.only(left: 12, right: 12),
                                separatorBuilder: (context, index) => Divider(
                                  height: .5,
                                  color: Color(0xffd3d3d3),
                                ),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) =>
                                    Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: Icon(
                                              Icons.videocam,size: 26.0,
                                            )),
                                        Expanded(
                                          flex: 8,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Video ${index+1}",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',color: Colors.black
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text( '${DateFormat.yMMMEd().format(DateTime.parse(snapshot.data.documents[index].data['time']))}',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins' , color: Colors.grey
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.play_circle_filled,
                                                    color: Colors.black,
                                                    size: 26.0,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context ,
                                                        builder: (BuildContext context){
                                                          return BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                              child: VideoPlayerWidget(snapshot.data.documents[index].data['message']));
                                                        }
                                                    );
                                                  }
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            }
                        )
                    ),
                    new Container(
                      child:StreamBuilder(
                        stream: Firestore.instance.collection("chatRoom").
                        document(widget.ID).collection("chats").where('message type',isEqualTo: "file").
                        orderBy('time',descending:true).snapshots(),
                        builder: (context , snapshot){
                          if(!snapshot.hasData){
                            return Center(child: CircularProgressIndicator());
                          }else{
                            return ListView.separated( // show the list of files
                              padding: EdgeInsets.only(left: 12, right: 12),
                              separatorBuilder: (context, index) => Divider(
                                height: .5,
                                color: Color(0xffd3d3d3),
                              ),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Icon(
                                            Icons.insert_drive_file,
                                          )),
                                      Expanded(
                                        flex: 8,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "File $index",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',color: Colors.black
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text( '${DateFormat.yMMMEd().format(DateTime.parse(snapshot.data.documents[index].data['time']))}',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins' , color: Colors.grey
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.file_download,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  downloadFile(snapshot.data.documents[index].data['message']);
                                                }
                                                )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
                    ),
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
