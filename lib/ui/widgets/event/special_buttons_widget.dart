import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/repository/login_repository.dart';

class SpecialButtons extends StatefulWidget {
  
  final String lat, lon;
  final int eventId;

  const SpecialButtons({
    @required this.lat,
    @required this.lon,
    this.eventId,
    Key key
  }) : super(key: key);

  @override
  _SpecialButtonsState createState() => _SpecialButtonsState();
}

class _SpecialButtonsState extends State<SpecialButtons> {
  
  @override
  Widget build(BuildContext context) {

    bool isLogin = Provider.of<LoginRepository>(context, listen: false).isLogin();

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(top: 30, left: 80.0, right: 80.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.Colors.loginGradientStart,
                Theme.Colors.loginGradientEnd
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight
            ),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                offset: new Offset(3.0, 3.0),
                color: Colors.black45
              )
            ]  
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.location_on),
                onPressed: _launchmap,
              ),
              Spacer(),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.share),
                onPressed: () => Share.share('check out my website https://rumbero.live', subject: 'Look what I made!'),
              ),
            ],
          ),  
        ),
        Center(
          child: FloatingActionButton(
            child: Icon(
              Icons.local_play, 
              color: Theme.Colors.loginGradientEnd,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              if(isLogin){

                final List<String> _params = [
                  widget.eventId.toString(),
                  Provider.of<LoginRepository>(context, listen: false).getUserId().toString(),
                ];

                Navigator.pushNamed(
                  context, 
                  '/ticket',
                  arguments: _params   
                );
              } 
              else 
                Navigator.of(context).pushNamed('/login');
            },
          ),
        )
      ],
    );
  }

  void _launchmap() async {
  
    final String googleMapsUrl = "comgooglemaps://?center="+widget.lat+","+widget.lon;
    final String appleMapsUrl = "https://maps.apple.com/?q="+widget.lat+","+widget.lon;

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }
}