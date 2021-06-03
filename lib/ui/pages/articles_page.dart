import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:url_launcher/url_launcher.dart';

import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';
import 'package:rumbero/logic/entity/models/marca_model.dart';

class ArticlesPage extends StatelessWidget {
  final Marca marca;
  final String tagId;

  const ArticlesPage({@required this.marca, @required this.tagId});

  void _launchContacto(String url) async {
    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;
    double _wCard = (_screenSize.width - 60) / 2;
    double _hCard = (_screenSize.height) / 4;

    return Scaffold(
      floatingActionButton:
          marca.contacto != null ? _reservar(marca.contacto) : SizedBox(),
      body: ListView(
        children: <Widget>[
          header(
              _orientation != Orientation.landscape
                  ? _screenSize.height * .25
                  : _screenSize.height * .55,
              context),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              marca.marca,
              style: new TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0,
                  letterSpacing: 1.0),
            ),
          ),
          body(_wCard, _hCard),
          redes()
        ],
      ),
    );
  }

  Widget _reservar(String contacto) {
    return FloatingActionButton.extended(
        icon: Icon(
          Icons.add_to_home_screen,
          color: Colors.white,
        ),
        label: Text(
          'Reservar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.Colors.loginGradientEnd,
        onPressed: () => _launchContacto(contacto));
  }

  Widget body(double width, double height) {
    List<Articulo> articulos = marca.articulos;
    return Wrap(
      children: List.generate(articulos.length,
          (index) => article(articulos[index], width, height)),
    );
  }

  Widget article(Articulo articulo, double width, double height) {
    String precio = '\u{0024}' + articulo.precio.toString();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
      child: Stack(alignment: Alignment.bottomLeft, children: <Widget>[
        Container(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(articulo.imagen),
              placeholder: AssetImage('assets/img/tempo.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
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
                  ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                articulo.articulo,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 17.0),
              ),
              Text(
                precio,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget header(double alto, context) {
    return Stack(
      alignment: Alignment(.5, 1.0),
      children: <Widget>[
        Container(
          width: double.infinity,
          height: alto,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Hero(
                tag: tagId,
                child: Image.network(
                  marca.imagen,
                  fit: BoxFit.cover,
                )),
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
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget redes() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RedesWrap(redes: marca.redes),
    );
  }
}
