import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class CustomFlexibleAppBar extends StatelessWidget {
  final double appBarHeight = 66.0;
  final String urlImage;
  final String follows;
  final String followers;

  const CustomFlexibleAppBar({
    @required this.urlImage,
    @required this.follows,
    @required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(urlImage), fit: BoxFit.cover)),
      height: statusBarHeight + appBarHeight,
      child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Theme.Colors.loginGradientEnd.withOpacity(0.0),
                    Theme.Colors.loginGradientStart,
                  ],
                  stops: [
                    0.7,
                    1.0
                  ]))),
    );
  }
}
