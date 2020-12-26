import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

import 'package:rumbero/ui/widgets/card_slider_widget.dart';

class EventPage extends StatelessWidget {

  final List<EventModelResponse> eventos;

  const EventPage({Key key, this.eventos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Mis Eventos', style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold
          )),
        ),
        CardSlider(events: eventos)
      ],
    );
  }
}