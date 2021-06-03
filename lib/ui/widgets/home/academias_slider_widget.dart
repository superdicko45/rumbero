import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/entity/models/category_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class AcademySlider extends StatelessWidget {
  final List<AcademyModelResponse> academias;

  const AcademySlider({@required this.academias});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;
    final double _width = _orientation == Orientation.landscape
        ? _screenSize.width * .4
        : _screenSize.width * .7;

    return Container(
        height: _orientation == Orientation.landscape
            ? _screenSize.height * .8
            : _screenSize.height * .35,
        child: LayoutBuilder(builder: (context, contraint) {
          return ListView.builder(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.horizontal,
              itemCount: academias.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _card(contraint, ctxt, _width, academias[index]);
              });
        }));
  }

  Widget _card(BoxConstraints constraint, BuildContext context, double width,
      AcademyModelResponse academia) {
    final String _tagId = UniqueKey().toString();
    final List<String> _params = [
      academia.academiasId.toString(),
      _tagId,
      academia.nombre,
      academia.perfilImagen
    ];

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      elevation: 7.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/academy', arguments: _params);
        },
        child: Column(
          children: <Widget>[
            Container(
                height: constraint.maxHeight * .45,
                width: width,
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
                    imageCover(academia.perfilImagen, _tagId),
                    Wrap(
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Chip(
                            elevation: 15.0,
                            backgroundColor: Theme.Colors.loginGradientStart,
                            label: new Text(
                              academia.stars == null
                                  ? '0.0'
                                  : academia.stars.substring(0, 3),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                //height: constraint.maxHeight * .45,
                width: width,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20)),
                ),
                child: footer(constraint.maxHeight * .1, academia),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageCover(String url, String tagCard) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)),
      child: Hero(
        tag: tagCard,
        child: FadeInImage(
          imageErrorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Container(
              width: 130.0,
              height: 130.0,
              child: Image.asset('assets/img/no-image.jpg'),
            );
          },
          image: NetworkImage(url),
          placeholder: AssetImage('assets/img/tempo.gif'),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  Widget footer(double layoutChip, AcademyModelResponse academia) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Text(
            academia.nombre,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
            child: academia.stars == null
                ? Text(
                    'Sin reseñas',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.Colors.loginGradientStart,
                    ),
                  )
                : rating(double.parse(academia.stars), academia.total)),
        chipSlider(layoutChip, academia.tags)
      ],
    );
  }

  Widget rating(double stars, int comments) {
    return Column(
      children: [
        RatingBar(
          itemSize: 22.0,
          initialRating: stars,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          ignoreGestures: true,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (start) {},
        ),
        Text(
          comments > 1 ? '$comments reseñas' : '1 reseña',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget chipSlider(double height, List<Category> categories) {
    return Container(
        height: height * 1.5,
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
        color: Theme.Colors.loginGradientStart,
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
