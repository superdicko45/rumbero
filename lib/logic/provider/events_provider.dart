import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/models/event_model.dart';
import 'package:rumbero/logic/entity/models/ticket_model.dart';
import 'package:rumbero/logic/entity/responses/events_response.dart';

class EventProvider {
  static String url = "https://rumbero.live/api/eventos";
  static String urlUser = "https://rumbero.live/api/usuarios";
  SharedPreferences _prefs;

  Future<EventResponse> getMain() async {
    String city = await getCurrentCity();

    final error =
        "Ocurrío un error al cargar la información, intenta más tarde!";

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
    final error =
        "Ocurrío un error al cargar la información, intenta más tarde!";

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

  Future<Ticket> addEvent(String eventId) async {
    final int _idUser = await _getIdUser();
    Map data = {'evento_id': eventId, 'usuario_id': _idUser};

    String body = json.encode(data);

    final error =
        "Ocurrío un error al guardar la información, intenta más tarde!";

    try {
      final response = await http.post(
        '$urlUser/addEvent',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return Ticket.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return Ticket.withError(error);
      }
    } catch (e) {
      return Ticket.withError(error);
    }
  }

  Future<bool> checkEvent(String eventId) async {
    final int _idUser = await _getIdUser();

    Map data = {'evento_id': eventId, 'usuario_id': _idUser};

    String body = json.encode(data);

    final error =
        "Exception occured: 500 stackTrace: Fetch evento $url/checkEvent";

    try {
      final response = await http.post(
        '$urlUser/checkEvent',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        dynamic data = json.decode(response.body);
        return data['error'];
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<int> _getIdUser() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('keyRumbero');
  }

  Future<String> getCurrentCity() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey('idCity'))
      return _prefs.getInt('idCity').toString();
    else
      return '1';
  }
}
