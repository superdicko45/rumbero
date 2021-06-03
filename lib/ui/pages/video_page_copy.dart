import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/model_reponses/video_model_response.dart';
import 'package:rumbero/ui/widgets/video_player_widget.dart';

class VideoPage extends StatefulWidget {
  final VideoModelResponse video;
  VideoPage({Key key, this.video}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VPlayer(urlVideo: 'https://www.youtube.com/embed/2JyW4yAyTl0'),
    );
  }
}
