import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/models/category_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;


class CardSlider extends StatelessWidget {

  final List<EventModelResponse> events;

  const CardSlider({@required this.events});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;
    final double _width = _orientation == Orientation.landscape 
      ? _screenSize.width * .5 
      : _screenSize.width * .7;

    return Container(
      height: _orientation == Orientation.landscape ? 
        _screenSize.height * .7 : _screenSize.height * .4,
      child: LayoutBuilder(builder: (context, contraint){
        return ListView.builder(
          padding: EdgeInsets.all(5.0),
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _card(contraint, ctxt, _width, events[index]);
          }  
        );
      }) 
    );
  }

  Widget _card(BoxConstraints constraint, BuildContext context, double width, EventModelResponse evento){
    
    final String _tagId = UniqueKey().toString();

    final List<String> _params = [
      evento.eventoId.toString(),
      _tagId,
      evento.promocional,
      evento.tipoEvento,
      evento.cover.toString()
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)
        )
      ),
      elevation: 7.0,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(
            context, 
            '/event',
            arguments: _params   
          );
        },
        child: Column(
          children: <Widget>[
            Container(
              height: constraint.maxHeight * .56,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  imageCover(evento.promocional, evento.eventoId, _tagId),
                  Wrap(
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          elevation: 15.0,
                          backgroundColor: Theme.Colors.loginGradientStart,
                          label: new Text(evento.tipoEvento, 
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )    ,
            ),
            Container(
              height: constraint.maxHeight * .35,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20)
                ),
              ),
              child: footer(constraint.maxHeight * .1, evento),
            )
          ],
        ),
      ),
    );
  }

  Widget imageCover(String url, int id, String tagCard){
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30)
      ),
      child: Hero(
        tag: tagCard,
        child: FadeInImage(
          image: NetworkImage(url),
          placeholder: AssetImage('assets/img/tempo.gif'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget footer(double layoutChip, EventModelResponse evento){

    final String ubicacion = evento.ciudad + ', ' + evento.colonia;
    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaInicio);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');
    
    String inicioD = formatter.format(inicioO);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(evento.titulo,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(ubicacion,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.Colors.loginGradientStart,
                  ),
                ),
              ),
              Text(inicioD,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.Colors.loginGradientEnd,
                ),
              ),
            ],
          ),
        ),
        chipSlider(layoutChip, evento.tags)
      ],
    );
  }

  Widget chipSlider(double height, List<Category> categories){
    return Container(
      height: height * 1.3,
      child: ListView.builder(
        padding: EdgeInsets.all(5.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return chip(context, categories[index].genero);
        },
      )  
    );
  }

  Widget chip(BuildContext context, String text){
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        ),
        color: Theme.Colors.loginGradientEnd, 
      ),
      child: InkWell(
        onTap: (){Navigator.pushNamed(context, '/results');},
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

}