import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rumbero/logic/entity/models/academy_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class PromoPage extends StatelessWidget {
  final Promo promo;

  const PromoPage({this.promo, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    final double _width = _orientation == Orientation.landscape
        ? _screenSize.width * .5
        : _screenSize.width * .75;

    final double _mgTop = _orientation == Orientation.landscape
        ? _screenSize.height * .05
        : _screenSize.height * .1;

    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: Theme.Colors.myBoxDecBackG,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: _mgTop),
            child: _body(_width, context),
          )),
    );
  }

  Widget _backIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _body(double _width, BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _backIcon(ctx),
        Stack(
          alignment: Alignment(0, -1.3),
          children: [_main(_width), imgCover(_width - 20)],
        )
      ],
    );
  }

  Widget _main(double _width) {
    var fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(promo.caducidad);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');

    String caducidad = formatter.format(fecha);

    const TextStyle hard = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);

    const TextStyle fade = TextStyle(
        fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black38);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 115),
        height: 500,
        width: _width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  backgroundColor: Theme.Colors.loginGradientEnd,
                  label: Text(
                    promo.promo,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            lineDoted(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Caducidad', style: hard),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        caducidad,
                        style: fade,
                      ),
                    ),
                    Text('Descripción', style: hard),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                          width: _width * 0.8,
                          child: Text(
                            promo.descripcion,
                            style: fade,
                            maxLines: 10,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imgCover(double _width) {
    return Hero(
      tag: promo.promoId,
      child: ClipRRect(
        child: Image.network(
          promo.imagen,
          width: _width,
          height: 160,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );
  }

  Widget lineDoted() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(
            150 ~/ 10,
            (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                    height: 2,
                  ),
                )),
      ),
    );
  }
}
