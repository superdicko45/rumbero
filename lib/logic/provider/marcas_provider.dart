import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumbero/logic/entity/responses/marcas_response.dart';

class MarcaProvider {
  static String url = "https://rumbero.live/api";

  Future<MarcasResponse> getData() async {
    final error = "Exception occured: 500 stackTrace: Fetch Marcas";

    try {
      final response = await http.get('$url/marcas');

      if (response.statusCode == 200) {
        // Si el servidor devuelve una repuesta OK, parseamos el JSON
        return MarcasResponse.fromJson(json.decode(response.body));
      } else {
        // Si esta respuesta no fue OK, lanza un error.
        print(error);
        return MarcasResponse.withError();
      }
    } catch (e) {
      return MarcasResponse.withError();
    }
  }
}
