import 'package:rumbero/logic/entity/models/marca_model.dart';

class MarcasResponse {
  List<Marca> marcas;
  List<Tags> tags;
  bool error;

  MarcasResponse(this.marcas, this.tags, this.error);

  MarcasResponse.fromJson(Map<String, dynamic> json) {
    if (json['marcas'] == null && json['categorias'] == null)
      error = true;
    else
      error = false;

    if (json['categorias'] != null) {
      tags = new List<Tags>();
      json['categorias'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }

    if (json['marcas'] != null) {
      marcas = new List<Marca>();
      json['marcas'].forEach((v) {
        marcas.add(new Marca.fromJson(v));
      });
    }
  }

  MarcasResponse.withError() {
    error = true;
  }
}
