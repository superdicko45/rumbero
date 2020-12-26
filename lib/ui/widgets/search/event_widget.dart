import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:intl/intl.dart';

import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

class EventResult extends StatelessWidget {

  final EventModelResponse evento;

  const EventResult({@required this.evento});

  @override
  Widget build(BuildContext context) {

    final String _tagId = UniqueKey().toString();
    final String ubicacion = evento.ciudad + ', ' + evento.colonia;
    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaInicio);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');
    String inicioD = formatter.format(inicioO);

    final List<String> _params = [
      evento.eventoId.toString(),
      _tagId,
      evento.promocional,
      evento.tipoEvento,
      evento.cover.toString()
    ];
    
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
        ),
        elevation: 7.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: ListTile(
          onTap: () => Navigator.pushNamed(
            context, 
            '/event',
            arguments: _params   
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          leading: imageCover(evento.promocional),
          title: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        evento.titulo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.Colors.loginGradientStart, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        ubicacion,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.Colors.loginGradientStart
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              chip(evento.tipoEvento),
              Text(inicioD),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.Colors.loginGradientEnd, size: 30.0)
        )
      ),
    );
  }

  Widget imageCover(String url){
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20)
      ),
      child: FadeInImage(
        width: 100,
        image: NetworkImage(url),
        placeholder: AssetImage('assets/img/tempo.gif'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget chip(String text){
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        ),
        color: Theme.Colors.loginGradientStart, 
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      )
    );
  }

}