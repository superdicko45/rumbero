import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rumbero/logic/entity/model_reponses/video_model_response.dart';

class VideosSwiper extends StatelessWidget {

  final List<VideoModelResponse> videos;

  const VideosSwiper({@required this.videos});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    double height = _orientation == Orientation.landscape ? 
        _screenSize.height * .4 : _screenSize.height * .18;

    double width = _orientation == Orientation.landscape ? 
        _screenSize.width * .4 : _screenSize.width * .6;    

    return Container(
       height: height,
      child: LayoutBuilder(builder: (context, contraint){
        return ListView.builder(
          padding: EdgeInsets.all(5.0),
          scrollDirection: Axis.horizontal,
          itemCount: videos.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return card(videos[index], ctxt, height, width);
          }  
        );
      }) 
    );
  }

  Widget card(VideoModelResponse video, BuildContext context, double height, double width){

    return InkWell(
      onTap: () => _launchmap(video.url),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(video.thumbnail),
            placeholder: AssetImage('assets/img/tempo.gif'),
            fit: BoxFit.cover,
            height: height,
            width: width,
          )     
        ),
      ),
    );
  }

  void _launchmap(String url) async {
  
    if (await canLaunch(url)) {
      await launch(url);
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

}