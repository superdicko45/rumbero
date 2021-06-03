import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import 'package:rumbero/logic/entity/models/show_user_model.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';

import 'package:rumbero/logic/entity/responses/login_response.dart';

class UserProvider {
  SharedPreferences _prefs;
  static String url = "https://rumbero.live/api/usuarios";

  Future<User> showUser(String idUser) async {
    final error =
        "Ocurrío un error al cargar la información, intenta más tarde!";

    try {
      final response = await http.get('$url/show/$idUser');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return User.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return User.withError(error);
      }
    } catch (e) {
      return User.withError(error);
    }
  }

  void saveToken(String token) async {
    Map data = {'token': token};

    String body = json.encode(data);

    try {
      await http.post(
        '$url/token',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      // TODO
    }

    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('tokenFCM')) _prefs.setString('tokenFCM', token);
  }

  Future<AuthResponse> createUser(String uid, String name, String email) async {
    String token = await getToken();
    Map data = {'uid': uid, 'name': name, 'email': email, 'token': token};

    String body = json.encode(data);

    final error =
        "Ocurrío un error al guardar la información, intenta más tarde!";

    try {
      final response = await http.post(
        '$url/store',
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return AuthResponse.withError(error);
      }
    } catch (e) {
      return AuthResponse.withError(error);
    }
  }

  Future<List<Galeria>> getGalery(int userId, int page) async {
    final error =
        "Exception occured: 500 stackTrace: Fetch user $url/galeria - $userId";

    List<Galeria> galeria = new List<Galeria>();

    try {
      final response = await http.get(
        '$url/galeria/$userId?page=$page',
      );

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
    } catch (e) {
      return galeria;
    }
  }

  Future<bool> updateGalery(int userId, List<ByteData> files) async {
    Uri uri = Uri.parse('$url/addImages');

    http.MultipartRequest request = http.MultipartRequest("POST", uri);

    request.fields['usuario_id'] = userId.toString();

    files.forEach((element) {
      List<int> imageData = element.buffer.asUint8List();

      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'images[]',
        imageData,
        filename: 'some-file-name.jpg',
        contentType: MediaType("image", "jpg"),
      );

      request.files.add(multipartFile);
    });

    final error =
        "Exception occured: 500 stackTrace: Fetch galery user $url/galeria - $userId";

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> updateImgProfile(int userId, List<ByteData> files) async {
    Uri uri = Uri.parse('$url/profileImg');

    http.MultipartRequest request = http.MultipartRequest("POST", uri);

    request.fields['usuario_id'] = userId.toString();

    files.forEach((element) {
      List<int> imageData = element.buffer.asUint8List();

      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageData,
        filename: 'some-file-name.jpg',
        contentType: MediaType("image", "jpg"),
      );

      request.files.add(multipartFile);
    });

    final error =
        "Exception occured: 500 stackTrace: Fetch galery user $url/imgProfile - $userId";

    try {
      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getToken() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('tokenFCM');
  }
}
