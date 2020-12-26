import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/models/blog_model.dart';
import 'package:rumbero/logic/entity/models/comentario_model.dart';

class BlogProvider{

  static String url = "https://rumbero.live/api/blogs";
  SharedPreferences _prefs;

  Future<Blog> showBlog(String id) async {
    
    final response = await http.get('$url/$id');
    final error = "Exception occured: 500 stackTrace: Fetch categories";
    
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return Blog.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return Blog.withError(error);
    }
  }

  Future<List<Comentario>> getComentarios(String id, String page) async {
    
    final response = await http.get('$url/comentarios/$id?page=$page');
    final error = "Exception occured: 500 stackTrace: Fetch comentarios";
    
    List<Comentario> _comentarios = new List<Comentario>();

    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      
      Map<String, dynamic> _response = json.decode(response.body);
      List<dynamic> _ownComments = _response['data'];

      _ownComments.forEach((value) {
        _comentarios.add(new Comentario.fromJson(value));
      });

      return _comentarios;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return _comentarios;
    }
  }

  Future<Comentario> addComentario(String comment, String blogId) async {

    final int _idUser = await _getIdUser();
    
    Map data = {
      'blog_id'    : blogId,
      'usuario_id' : _idUser,
      'comentario' : comment
    };

    String body = json.encode(data);

    final response = await http.post(
      '$url/addComentario',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final error = "Exception occured: 500 stackTrace: Fetch user $url/addComentario";

    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return Comentario.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return Comentario();
    }
  }

  Future<int> _getIdUser() async {

    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('keyRumbero');
  }
}