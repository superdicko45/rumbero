import 'package:rumbero/logic/entity/models/category_model.dart';

class AcademyModelResponse {
  int academiasId;
  String perfilImagen;
  String nombre;
  String stars;
  int total;
  List<Category> tags;

  AcademyModelResponse(
      {this.academiasId,
      this.perfilImagen,
      this.nombre,
      this.stars,
      this.total,
      this.tags});

  AcademyModelResponse.fromJson(Map<String, dynamic> json) {
    academiasId = json['academias_id'];
    perfilImagen = json['perfil_imagen'];
    nombre = json['nombre'];
    stars = json['stars'];
    total = json['total'];
    if (json['tags'] != null) {
      tags = new List<Category>();
      json['tags'].forEach((v) {
        tags.add(new Category.fromJson(v));
      });
    }
  }

  
}