import 'package:flutter/material.dart';

import 'package:numeral/numeral.dart';

import 'package:rumbero/logic/entity/model_reponses/video_model_response.dart';

import 'package:rumbero/ui/pages/video_page.dart';

class VideosSwiper extends StatelessWidget {
  final List<VideoModelResponse> videos;

  const VideosSwiper({Key key, this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    double height = _orientation == Orientation.landscape
        ? _screenSize.height * .72
        : _screenSize.height * .4;

    double width = _orientation == Orientation.landscape
        ? _screenSize.width * .4
        : _screenSize.width * .6;

    return Container(
        height: height,
        child: LayoutBuilder(builder: (context, contraint) {
          return ListView.builder(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return card(videos[index], ctxt, height, width);
              });
        }));
  }

  Widget card(VideoModelResponse video, BuildContext context, double height,
      double width) {
    final String texto =
        video.plays == 1 ? ' - reproducción' : ' - reproducciones';
    final String plays = Numeral(video.plays).value() + texto;

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPage(
                    video: video,
                  ))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Container(
                      height: height,
                      width: width,
                      child: Image.asset('assets/img/no-image.jpg'),
                    );
                  },
                  image: NetworkImage(video.thumbnail),
                  placeholder: AssetImage('assets/img/tempo.gif'),
                  fit: BoxFit.cover,
                  height: height,
                  width: width,
                )),
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black,
                      ],
                      stops: [
                        0.8,
                        1.0
                      ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    video.name,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    plays,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
