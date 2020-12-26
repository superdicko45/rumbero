import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/models/redes_model.dart';

class RedesModelResponse {
  List<General> catalogo;
  List<Redes> redes;
  bool error;

  RedesModelResponse({this.catalogo, this.redes});

  RedesModelResponse.fromJson(Map<String, dynamic> json) {
    
    if (json['redes'] != null) {
      redes = new List<Redes>();
      json['redes'].forEach((v) {
        redes.add(new Redes.fromJson(v));
      });
    }

    if (json['catRedes'] != null) {
      catalogo = new List<General>();
      json['catRedes'].forEach((v) {
        catalogo.add(new General.fromJson(v));
      });
    }
  }

  RedesModelResponse.withError(String errorValue)
      : catalogo = List<General>(),
        redes = List<Redes>(),
        error = true;
  
}