import 'package:rumbero/logic/entity/models/category_model.dart';

class EventModelResponse {
  int eventoId;
  String promocional;
  String titulo;
  String ciudad;
  String colonia;
  String fechaInicio;
  String fechaFinal;
  String tipoEvento;
  int cover;
  List<Category> tags;

  EventModelResponse(
      {this.eventoId,
      this.promocional,
      this.titulo,
      this.ciudad,
      this.colonia,
      this.fechaInicio,
      this.fechaFinal,
      this.tipoEvento,
      this.cover,
      this.tags});

  EventModelResponse.fromJson(Map<String, dynamic> json) {
    eventoId = json['evento_id'];
    promocional = json['promocional'];
    titulo = json['titulo'];
    ciudad = json['ciudad'];
    colonia = json['colonia'];
    fechaInicio = json['fecha_inicio'];
    fechaFinal = json['fecha_final'];
    tipoEvento = json['tipo_evento'];
    cover = json['cover'];
    if (json['tags'] != null) {
      tags = new List<Category>();
      json['tags'].forEach((v) {
        tags.add(new Category.fromJson(v));
      });
    }
  }

  
}