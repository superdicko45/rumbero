import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VPlayer extends StatefulWidget {

  final String urlVideo;

  VPlayer({@required this.urlVideo, Key key}) : super(key: key);

  @override
  _VPlayerState createState() => _VPlayerState();
}

class _VPlayerState extends State<VPlayer> {

  VideoPlayerController controller;

  @override
  void initState() {

    //controller = VideoPlayerController.network(
    //    widget.urlVideo)
    //  ..initialize().then((_) {
    //    setState(() {});
    //  });

    controller = VideoPlayerController.asset(
        'assets/video/donde.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    controller.setLooping(true);
    controller.setVolume(25.0); 
    
    super.initState();
  }

  @override
  void dispose() {
    
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        controller.value.initialized
          ? AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          : Image.asset('assets/img/tempo.gif'),      
        buttonVPlayer()

      ],
    );
  }

  Widget buttonVPlayer(){
    return Container(
      width: 100,
      child: GestureDetector(
        onTap: (){
          setState(() {
            controller.value.isPlaying
              ? controller.pause()
              : controller.play();
          });
        },
        child: Container(           
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: new IconTheme(
                  data: new IconThemeData(
                    size: 50,
                    color: Colors.white
                  ), 
                  child: Icon(  
                    controller.value.isPlaying 
                      ? Icons.pause
                      : Icons.play_arrow
                  ) 
                ),                   
              )
            ],
          ),
        ),
      ),
    );
  }
}