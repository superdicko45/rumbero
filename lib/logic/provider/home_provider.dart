import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumbero/logic/entity/responses/home_response.dart';

class HomeProvider{

  static String url = "https://rumbero.live/api/home/dashboard";

  Future<HomeResponse> getData(String city) async {
    
    final error = "Exception occured: 500 stackTrace: Fetch dashboard";
    
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
}