import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';

class ArticlesPage extends StatefulWidget {

  final dynamic params;

  const ArticlesPage({
    @required this.params,
    Key key
  }) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {


  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: ListView(
        children: <Widget>[

          header(
            widget.params,
            _orientation != Orientation.landscape 
              ? _screenSize.height * .25 
              : _screenSize.height * .55,
            context   
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Only Dance',
              style: new TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 19.0,
                letterSpacing: 1.0
              ),
            ),
          ),
          
          body(),
          button()
        ],
      ),
    );
  }

  Widget body() {

    List<String> images = [
      'https://www.dhresource.com/0x0/f2/albu/g7/M00/80/E7/rBVaSVrxeFyAe-ihAAI5-jTbl6o547.jpg/3-colors-latin-dance-dresses-for-sale-dress.jpg',
      'https://stylelovely.com/wp-content/uploads/vestidos_de_novia-baile-vestido_encaje-revolve_clothing.jpg',
      'https://images-eu.ssl-images-amazon.com/images/I/31ajE11%2BEbL.jpg',
      'https://www.goandance.com/es/media/images-manager/Post%20142/vestido-nur.jpg',
      'https://www.dhresource.com/0x0/f2/albu/g7/M00/80/E7/rBVaSVrxeFyAe-ihAAI5-jTbl6o547.jpg/3-colors-latin-dance-dresses-for-sale-dress.jpg',
      'https://stylelovely.com/wp-content/uploads/vestidos_de_novia-baile-vestido_encaje-revolve_clothing.jpg',
      'https://images-eu.ssl-images-amazon.com/images/I/31ajE11%2BEbL.jpg',
      'https://www.goandance.com/es/media/images-manager/Post%20142/vestido-nur.jpg'
    ];

    return Wrap(
      children: List.generate(images.length, (index) => article(images[index])),
    );
  }

  Widget article(String image){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width - 60 ) / 2,
            height: (MediaQuery.of(context).size.height) / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(image),
                placeholder: AssetImage('assets/img/tempo.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height) / 4,
            width: (MediaQuery.of(context).size.width - 60 ) / 2,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  //Theme.Colors.loginGradientEnd.withOpacity(0.0),
                  //Theme.Colors.loginGradientStart,
                  Colors.black12,
                  Colors.black87,
                ],
                stops: [
                  0.6,
                  1.0
                ]
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Vestido dama',
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 17.0
                  ),
                ),
                Text(
                  '\u{0024}350.0',
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                  ),
                ),
              ],
            ),
          ),
        ] 
      ),
    );
  }

  Widget header(List<dynamic> params, double alto, context){

    return Stack(
      alignment: Alignment(.5, 1.0),
      children: <Widget>[
        Container(
          width: double.infinity,
          height: alto,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Hero(
              tag: widget.params[1],
              child: Image.asset(
                params[0],
                fit: BoxFit.cover,
              )
            ),
          ),
        ),
        Container(
          height: alto,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.black26,
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget button(){
    return Container(
      decoration: Theme.Colors.myBoxDecButton,
      child: MaterialButton(
        onPressed: (){},
        child: MaterialButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "VISITAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontFamily: "WorkSansBold"
              ),
            ),
          ),
          onPressed:(){}
        )
      )
    );
  }

}