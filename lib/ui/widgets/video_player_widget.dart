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
  bool isMuted;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.urlVideo)
      ..initialize().then((_) {
        setState(() {});
      });

    controller.setLooping(true);
    controller.setVolume(1.0);
    isMuted = false;

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
      alignment: Alignment.bottomCenter,
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

  Widget buttonVPlayer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black45.withOpacity(0.5),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMuted
                      ? controller.setVolume(1.0)
                      : controller.setVolume(0.0);

                  isMuted ? isMuted = false : isMuted = true;
                });
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: new IconTheme(
                          data:
                              new IconThemeData(size: 20, color: Colors.white),
                          child: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_down)),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: Colors.black45.withOpacity(0.5),
            ),
            child: GestureDetector(
              onTap: () {
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
                          data:
                              new IconThemeData(size: 30, color: Colors.white),
                          child: Icon(controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
