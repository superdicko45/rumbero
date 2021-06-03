import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';

import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

class SearchProvider {
  static String url = "https://rumbero.live/api";

  Future<List<String>> getSuggestions(String q) async {
    final error = "Exception occured: 500 stackTrace: Fetch suggestions";
    List<String> results = new List<String>();

    try {
      final response = await http.get('$url/sugerencias/$q');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        List<dynamic> suggestions = json.decode(response.body);

        suggestions.forEach((element) {
          results.add(element);
        });

        return results;
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return results;
      }
    } catch (e) {
      return results;
    }
  }

  Future<SearchResponse> getResults(Search filtro) async {
    final String query = filtro.toString();
    print('$url/search?$query');
    final error = "Exception occured: 500 stackTrace: Fetch search";

    try {
      final response = await http.get('$url/search?$query');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON

        return SearchResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return new SearchResponse.withError();
      }
    } catch (e) {
      return new SearchResponse.withError();
    }
  }

  Future<Map<String, dynamic>> getData() async {
    final error = "Exception occured: 500 stackTrace: Fetch filter";
    Map<String, dynamic> _data = new Map<String, dynamic>();

    try {
      final response = await http.get('$url/filter');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        Map<String, dynamic> _response = json.decode(response.body);
        List<General> _categorias = new List<General>();
        List<General> _ciudades = new List<General>();

        _response['categorias'].forEach((value) {
          _categorias.add(new General.fromJson(value));
        });

        _response['ciudades'].forEach((value) {
          _ciudades.add(new General.fromJson(value));
        });

        _data = {'categorias': _categorias, 'ciudades': _ciudades};

        return _data;
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return _data;
      }
    } catch (e) {
      return _data;
    }
  }

  Future<List<EventModelResponse>> getEventos(
      Search filtro, String page) async {
    final String query = filtro.toString();
    final error = "Exception occured: 500 stackTrace: Fetch search/eventos";
    List<EventModelResponse> eventos = new List<EventModelResponse>();

    try {
      final response = await http.get('$url/search/eventos?page=$page&$query');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        List<dynamic> data = json.decode(response.body);

        data.forEach((emd) {
          eventos.add(new EventModelResponse.fromJson(emd));
        });

        return eventos; //SearchResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return eventos;
      }
    } catch (e) {
      return eventos;
    }
  }

  Future<List<AcademyModelResponse>> getAcademias(
      Search filtro, String page) async {
    final String query = filtro.toString();
    final error = "Exception occured: 500 stackTrace: Fetch search/academias";
    List<AcademyModelResponse> academias = new List<AcademyModelResponse>();

    try {
      final response =
          await http.get('$url/search/academias?page=$page&$query');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        List<dynamic> data = json.decode(response.body);

        data.forEach((emd) {
          academias.add(new AcademyModelResponse.fromJson(emd));
        });

        return academias; //SearchResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return academias;
      }
    } catch (e) {
      return academias;
    }
  }

  Future<List<UserModelResponse>> getUsuarios(
      Search filtro, String page) async {
    final String query = filtro.toString();
    final error = "Exception occured: 500 stackTrace: Fetch search/usuarios";
    List<UserModelResponse> usuarios = new List<UserModelResponse>();

    try {
      final response = await http.get('$url/search/usuarios?page=$page&$query');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        List<dynamic> data = json.decode(response.body);

        data.forEach((emd) {
          usuarios.add(new UserModelResponse.fromJson(emd));
        });

        return usuarios; //SearchResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return usuarios;
      }
    } catch (e) {
      return usuarios;
    }
  }

  Future<List<BlogModelResponse>> getBlogs(String page) async {
    final error = "Exception occured: 500 stackTrace: Fetch search/blogs";
    List<BlogModelResponse> blogs = new List<BlogModelResponse>();

    try {
      final response = await http.get('$url/search/blogs?page=$page');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        List<dynamic> data = json.decode(response.body);

        data.forEach((emd) {
          blogs.add(new BlogModelResponse.fromJson(emd));
        });

        return blogs; //SearchResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return blogs;
      }
    } catch (e) {
      return blogs;
    }
  }
}
