import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class NoInfo extends StatelessWidget {

  final String text;
  final String svg;

  const NoInfo({
    Key key, 
    @required this.svg,
    @required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              'assets/svg/$svg',
              height: 200.0,
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54
            ),
          ),
        )
      ],
    );
  }

}