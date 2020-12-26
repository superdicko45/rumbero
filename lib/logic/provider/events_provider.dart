import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rumbero/logic/entity/models/event_model.dart';
import 'package:rumbero/logic/entity/models/ticket_model.dart';
import 'package:rumbero/logic/entity/responses/events_response.dart';

class EventProvider
{

  static String url = "https://rumbero.live/api/eventos";
  static String urlUser = "https://rumbero.live/api/usuarios";

  Future<EventResponse> getMain(String city) async {

    final error = "Exception occured: 500 stackTrace: Fetch categories $url/main/$city";
    
    try {
      
      final response = await http.get('$url/main/$city');
      
      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return EventResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return EventResponse.withError(error);
      }
    } catch (e) {
      return EventResponse.withError(error);
    }
  }

  Future<Evento> showEvent(String idEvent) async {
    
    final error = "Exception occured: 500 stackTrace: Fetch evento $url/show/$idEvent";
    
    try {
      
      final response = await http.get('$url/show/$idEvent');
      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return Evento.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return Evento.withError(error);
      }
    } catch (e) {
      print(error);
      return Evento.withError(error);
    }
  }

  Future<Ticket> addEvent(String eventId, String userId) async {
    
    Map data = {
      'evento_id'  : eventId,
      'usuario_id' : userId
    };

    String body = json.encode(data);

    final response = await http.post(
      '$urlUser/addEvent',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final error = "Exception occured: 500 stackTrace: Fetch evento $url/addEvent";
    
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return Ticket.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return Ticket.withError(error);
    }
  }
}