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

    final _orientation = MediaQuery.of(context).orientation;
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.Colors.loginGradientStart,
            Theme.Colors.loginGradientEnd
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight
        )
      ),
      height: statusBarHeight + appBarHeight,
      child: new Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              CircleAvatar(
                backgroundImage: NetworkImage(urlImage),
                maxRadius: 60,
              ),

              Expanded(
                child: _orientation != Orientation.landscape 
                  ? vertical()
                  : horizontal(),
              )

            ],
          ),
        )
      ),
    );
  }

  Widget vertical(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        wfollows(),
        button()
      ],
    );
  }

  Widget horizontal(){

    return Container(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: wfollows()),
          button()
        ],
      ),
    );
  }

  Widget wfollows(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Seguidores', style: TextStyle(
                color: Colors.white54,
                fontSize: 15
              )),
              Text(follows,style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold
              )),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Seguidos',style: TextStyle(
                color: Colors.white54,
                fontSize: 15
              )),
              Text(followers,style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget button(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text('Seguir'),
        textColor: Colors.white,
        color: Colors.red,
        elevation: 10,                
        onPressed: (){},
      ),
    );
  }

}