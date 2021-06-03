import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumbero/logic/entity/models/redes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/redes_model_response.dart';
import 'package:rumbero/logic/entity/profile/my_user_model.dart';

class EditProvider {
  static String url = "https://rumbero.live/api/usuarios";
  SharedPreferences _prefs;

  Future<List<EventModelResponse>> getEvents(int _page) async {
    final int _idUser = await _getIdUser();

    final error =
        "Exception occured: 500 stackTrace: Fetch user $url/events - $_idUser";

    List<EventModelResponse> eventos = new List<EventModelResponse>();

    try {
      final response = await http.get(
        '$url/events/$_idUser?page=$_page',
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        Map body = json.decode(response.body);

        body['data'].forEach((v) {
          eventos.add(new EventModelResponse.fromJson(v));
        });

        return eventos;
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return eventos;
      }
    } catch (e) {
      return eventos;
    }
  }

  Future<MyUser> showInfoUser() async {
    final int _idUser = await _getIdUser();
    Map data = {'usuario_id': _idUser};

    String body = json.encode(data);

    final error =
        "Ocurrío un error al cargar la información, intenta más tarde!";

    try {
      final response = await http.post(
        '$url/edit',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return MyUser.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return MyUser.withError(error);
      }
    } catch (e) {
      return MyUser.withError(error);
    }
  }

  Future<Map> updateGeneral(List<int> _new, List<int> _old, String _name,
      String _nick, String _desc, int _tipo, int _ciudad) async {
    final int _idUser = await _getIdUser();
    final error =
        "Ocurrío un error al guardar la información, intenta más tarde!";

    Map data = {
      'usuario_id': _idUser,
      'nombre': _name,
      'username': _nick,
      'tipo_id': _tipo,
      'descripcion': _desc
    };

    if (_new.length > 0) data.addAll({'newGeneros': _new});

    if (_old.length > 0) data.addAll({'oldGeneros': _old});

    String body = json.encode(data);

    //actualiza la ciudad
    updCurrentCity(_ciudad);

    try {
      final response = await http.post(
        '$url/update',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return json.decode(response.body);
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return {"error": true, "msg": error};
      }
    } catch (e) {
      print(error);
      return {"error": true, "msg": error};
    }
  }

  Future<bool> searchName(String username) async {
    final int _idUser = await _getIdUser();
    Map data = {'usuario_id': _idUser, 'username': username};

    String body = json.encode(data);

    try {
      final response = await http.post(
        '$url/searchName',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        Map bodyResponse = json.decode(response.body);
        return bodyResponse['error'];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> delEvento(int _eventId) async {
    final int _idUser = await _getIdUser();
    Map data = {'usuario_id': _idUser, 'evento_id': _eventId};

    String body = json.encode(data);

    try {
      await http.post(
        '$url/delEvent',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<RedesModelResponse> getRedes() async {
    final int _idUser = await _getIdUser();

    Map data = {'usuario_id': _idUser};

    final error = "Ocurrío un error al cargar la información!";

    String body = json.encode(data);

    try {
      final response = await http.post(
        '$url/redes',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return RedesModelResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return RedesModelResponse.withError(error);
      }
    } catch (e) {
      return RedesModelResponse.withError(error);
    }
  }

  Future<bool> updateRedes(
      List<Redes> _new, List<Redes> _upd, List<int> _old) async {
    int _idUser = await _getIdUser();

    Map data = {'usuario_id': _idUser};

    if (_new.length > 0) data.addAll({'newRedes': _new});

    if (_old.length > 0) data.addAll({'delRedes': _old});

    if (_upd.length > 0) data.addAll({'updRedes': _upd});

    String body = json.encode(data);

    try {
      final response = await http.post(
        '$url/updRedes',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getIdUser() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('keyRumbero');
  }

  Future<int> getCurrentCity() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey('idCity'))
      return _prefs.getInt('idCity');
    else
      return 1;
  }

  void updCurrentCity(int ciudad) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('idCity', ciudad);
  }
}
