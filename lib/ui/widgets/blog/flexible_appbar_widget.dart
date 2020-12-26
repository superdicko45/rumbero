import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class CustomFlexibleAppBar extends StatelessWidget {

  final double appBarHeight = 66.0;
  final String tagId;
  final String urlImage;
  final String title;

  const CustomFlexibleAppBar({
    @required this.tagId,
    @required this.urlImage,
    @required this.title
  });

  @override
  Widget build(BuildContext context) {

    return Hero(
      tag: tagId,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(urlImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Theme.Colors.loginGradientEnd.withOpacity(0.0),
                Theme.Colors.loginGradientStart.withOpacity(0.7),
              ],
              stops: [
                0.2,
                1.0
              ]
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}