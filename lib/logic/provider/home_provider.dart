import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rumbero/logic/entity/responses/home_response.dart';

class HomeProvider {
  static String url = "https://rumbero.live/api/home/dashboard";
  SharedPreferences _prefs;

  Future<HomeResponse> getData() async {
    final error =
        "Ocurrío un error al cargar la información, intenta más tarde!";

    String city = await getCurrentCity();

    try {
      final response = await http.get('$url/$city');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return HomeResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return HomeResponse.withError(error);
      }
    } catch (e) {
      return HomeResponse.withError(error);
    }
  }

  Future<String> getCurrentCity() async {
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey('idCity'))
      return _prefs.getInt('idCity').toString();
    else
      return '1';
  }
}
