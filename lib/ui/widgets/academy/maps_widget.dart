import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:rumbero/logic/entity/models/category_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/entity/models/academy_model.dart';

class SucursalPage extends StatelessWidget {
  final List<Sucursales> sucursales;

  const SucursalPage({Key key, @required this.sucursales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: sucursales.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return _card(_screenSize, sucursales[index]);
        });
  }

  void _launchmap(String lat, String lon) async {
    final String googleMapsUrl = "comgooglemaps://?center=" + lat + "," + lon;
    final String appleMapsUrl = "https://maps.apple.com/?q=" + lat + "," + lon;

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

  Widget _card(Size size, Sucursales sucursal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        elevation: 7.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  imageCover(sucursal.imagen, sucursal.week, sucursal.weekend,
                      sucursal.online),
                  Wrap(
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () =>
                              _launchmap(sucursal.latitud, sucursal.longitud),
                          child: Chip(
                            elevation: 15.0,
                            backgroundColor: Theme.Colors.loginGradientEnd,
                            label: new Text(
                              'Ver mapa',
                              style: TextStyle(color: Colors.white),
                            ),
                            avatar: Icon(
                              Icons.location_on,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              width: size.width * .8,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20)),
              ),
              child: footer(42, sucursal),
            )
          ],
        ),
      ),
    );
  }

  Widget imageCover(String image, int week, int weekend, int online) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.centerLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)),
          child: FadeInImage(
            image: NetworkImage(image),
            placeholder: AssetImage('assets/img/tempo.gif'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.centerRight,
                  end: FractionalOffset.centerLeft,
                  colors: [
                    Theme.Colors.loginGradientEnd.withOpacity(0.0),
                    Theme.Colors.loginGradientStart.withOpacity(0.9),
                  ],
                  stops: [
                    0.1,
                    1.0
                  ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              online == 1 ? textHerlper('* Online') : SizedBox(),
              week == 1 ? textHerlper('* Entre semana') : SizedBox(),
              weekend == 1 ? textHerlper('* Fines de semana') : SizedBox(),
            ],
          ),
        )
      ],
    );
  }

  Widget textHerlper(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget footer(double layoutChip, Sucursales sucursal) {
    final String ubicacion = sucursal.ciudad + ', ' + sucursal.colonia;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                sucursal.sucursal,
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ubicacion,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.Colors.loginGradientStart,
                ),
              ),
            ],
          ),
        ),
        chipSlider(layoutChip, sucursal.categorias)
      ],
    );
  }

  Widget chipSlider(double height, List<Category> categories) {
    return Container(
        height: height,
        child: ListView.builder(
          padding: EdgeInsets.all(5.0),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return chip(context, categories[index].genero);
          },
        ));
  }

  Widget chip(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
        color: Theme.Colors.loginGradientEnd,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/results');
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
