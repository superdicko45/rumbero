import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/models/academy_model.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/logic/entity/models/resena_model.dart';
import 'package:rumbero/logic/entity/responses/academy_response.dart';

class AcademyProvider
{

  static String url = "https://rumbero.live/api/academias";
  SharedPreferences _prefs;

  Future<AcademyResponse> getData(String city) async {
    
    final error = "Exception occured: 500 stackTrace: Fetch academias $url/main";
    
    try {
      
      final response = await http.get('$url/main/$city');
      
      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return AcademyResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return AcademyResponse.withError(error);
      }
    } catch (e) {
      return AcademyResponse.withError(error);
    }
  }

  Future<Academia> addResena(String resena, int academiaId, int cal) async {

    final int _idUser = await _getIdUser();
    
    Map data = {
      'academia_id'  : academiaId,
      'usuario_id'   : _idUser,
      'resena'       : resena,
      'calificacion' : cal
    };

    String body = json.encode(data);

    final response = await http.post(
      '$url/addResena',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final error = "Exception occured: 500 stackTrace: Fetch user $url/addComentario";

    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return Academia.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return Academia();
    }
  }
  
  Future<Academia> showAcademy(String idAcademy) async {
    
    final response = await http.get('$url/show/$idAcademy');
    final error = "Exception occured: 500 stackTrace: Fetch academia $url/show/$idAcademy";
    
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON

      return Academia.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return Academia.withError();
    }
  }

  Future<List<Galeria>> getGalery(int academyId, int page) async {

    final response = await http.get(
      '$url/galeria/$academyId?page=$page',
    );

    final error = "Exception occured: 500 stackTrace: Fetch academia $url/galeria - $academyId";

    List<Galeria> galeria = new List<Galeria>();

    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      Map body = json.decode(response.body);

      if (body['data'] != null) {
        
        body['data'].forEach((v) {
          galeria.add(new Galeria.fromJson(v));
        });
      }

      return galeria;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return galeria;
    }
  }

  Future<List<Resena>> getResena(int academyId, int page) async {

    final response = await http.get(
      '$url/resenas/$academyId?page=$page',
    );

    final error = "Exception occured: 500 stackTrace: Fetch academia $url/resenas - $academyId";

    List<Resena> resenas = new List<Resena>();

    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      Map body = json.decode(response.body);

      if (body['data'] != null) {
        
        body['data'].forEach((v) {
          resenas.add(new Resena.fromJson(v));
        });
      }

      return resenas;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return resenas;
    }
  }

  Future<int> _getIdUser() async {

    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('keyRumbero');
  }

}