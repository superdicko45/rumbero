import 'package:flutter/material.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/ui/pages/image_page.dart';
import 'package:rumbero/ui/pages/promo_page.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/models/redes_model.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';

import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';
import 'package:rumbero/ui/widgets/video_player_widget.dart';

class InfoPage extends StatelessWidget {
  final Academia academia;

  const InfoPage({Key key, @required this.academia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        redes(academia.redes),
        infoMain(),
        promo(academia.promo, context),
        videoPlayer(academia.video),
        description(),
        horario(context),
        costos(context),
        contact()
      ],
    );
  }

  Widget redes(List<Redes> redes) {
    return RedesWrap(redes: redes);
  }

  Widget videoPlayer(String url) {
    return url != null ? VPlayer(urlVideo: url) : SizedBox();
  }

  Widget infoMain() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(academia.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 27)),
          Text(academia.eslogan, style: TextStyle(color: Colors.black45))
        ],
      ),
    );
  }

  Widget promo(Promo promo, context) {
    return promo == null
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
                color: Theme.Colors.loginGradientEnd,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Hero(
                    tag: promo.promoId,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/img/tempo.gif'),
                      fit: BoxFit.cover,
                      image: NetworkImage(promo.imagen),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            promo.promo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                                fontFamily: "WorkSansMedium"),
                          ),
                        ],
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromoPage(
                                        promo: promo,
                                      )),
                            );
                          },
                          child: Text(
                            "Ver promo",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: "WorkSansMedium"),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget description() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(colors: [
            Theme.Colors.loginGradientStart,
            Theme.Colors.loginGradientEnd
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Text(academia.descripcion,
          style: TextStyle(color: Colors.white, fontSize: 17)),
    );
  }

  Widget horario(BuildContext ctx) {
    final List<Galeria> galeria = [
      Galeria(galeriaId: academia.horario, archivoFoto: academia.horario)
    ];

    return academia.horario != null
        ? Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text('Horario',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 27)),
                GestureDetector(
                    onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                            builder: (context) =>
                                ImagePage(galeria: galeria, index: 0))),
                    child: Image.network(academia.horario))
              ],
            ),
          )
        : SizedBox();
  }

  Widget costos(BuildContext ctx) {
    final List<Galeria> galeria = [
      Galeria(galeriaId: academia.costos, archivoFoto: academia.costos)
    ];

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text('Costos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 27)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                rangeText('Min', academia.rangoMin.toString()),
                rangeText('Max', academia.rangoMax.toString())
              ],
            ),
          ),
          academia.costos != null
              ? GestureDetector(
                  onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (context) =>
                              ImagePage(galeria: galeria, index: 0))),
                  child: Image.network(academia.costos))
              : SizedBox()
        ],
      ),
    );
  }

  Widget rangeText(String m, String range) {
    return Column(
      children: [
        Text(
          m,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          range,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        )
      ],
    );
  }

  Widget contact() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          academia.telefono != null
              ? Card(
                  child: ListTile(
                    leading: Icon(Icons.phone,
                        color: Theme.Colors.loginGradientStart),
                    title: Text(academia.telefono),
                    subtitle: Text('Telefono'),
                  ),
                )
              : SizedBox(),
          academia.pagina != null
              ? Card(
                  child: ListTile(
                    leading: Icon(Icons.public,
                        color: Theme.Colors.loginGradientStart),
                    title: Text(academia.pagina),
                    subtitle: Text('Sitio Web'),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
