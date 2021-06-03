import 'category_model.dart';
import 'redes_model.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

class Evento {
  int eventoId;
  String titulo;
  String promocional;
  int tipoEventoId;
  int cover;
  String contacto;
  String fechaInicio;
  String fechaFinal;
  String ciudad;
  String direccion;
  String colonia;
  String longitud;
  String latitud;
  String descripcion;
  String video;
  int activo;
  String createdAt;
  String updatedAt;
  String tipoEvento;
  List<UserModelResponse> invitados;
  List<UserModelResponse> organizadores;
  List<GaleriaEvento> galeriaEvento;
  List<Category> categorias;
  List<Redes> redes;
  bool error;

  Evento({
    this.eventoId,
    this.titulo,
    this.promocional,
    this.tipoEventoId,
    this.cover,
    this.contacto,
    this.fechaInicio,
    this.fechaFinal,
    this.ciudad,
    this.colonia,
    this.direccion,
    this.longitud,
    this.latitud,
    this.descripcion,
    this.video,
    this.activo,
    this.createdAt,
    this.updatedAt,
    this.tipoEvento,
    this.invitados,
    this.organizadores,
    this.galeriaEvento,
    this.categorias,
    this.redes,
  });

  Evento.fromJson(Map<String, dynamic> json) {
    error = false;

    eventoId = json['evento']['evento_id'];
    titulo = json['evento']['titulo'];
    promocional = json['evento']['promocional'];
    tipoEventoId = json['evento']['tipo_evento_id'];
    cover = json['evento']['cover'];
    contacto = json['evento']['contacto'];
    direccion = json['evento']['direccion'];
    fechaInicio = json['evento']['fecha_inicio'];
    fechaFinal = json['evento']['fecha_final'];
    ciudad = json['evento']['ciudad'];
    colonia = json['evento']['colonia'];
    longitud = json['evento']['longitud'];
    latitud = json['evento']['latitud'];
    descripcion = json['evento']['descripcion'];
    video = json['evento']['video'];
    activo = json['evento']['activo'];
    createdAt = json['evento']['created_at'];
    updatedAt = json['evento']['updated_at'];
    tipoEvento = json['evento']['tipo_evento'];

    if (json['invitados'] != null) {
      invitados = new List<UserModelResponse>();
      json['invitados'].forEach((v) {
        invitados.add(new UserModelResponse.fromJson(v));
      });
    }

    if (json['redes'] != null) {
      redes = new List<Redes>();
      json['redes'].forEach((v) {
        redes.add(new Redes.fromJson(v));
      });
    }

    if (json['generos'] != null) {
      categorias = new List<Category>();
      json['generos'].forEach((v) {
        categorias.add(new Category.fromJson(v));
      });
    }

    if (json['organizadores'] != null) {
      organizadores = new List<UserModelResponse>();
      json['organizadores'].forEach((v) {
        organizadores.add(new UserModelResponse.fromJson(v));
      });
    }

    if (json['galeria_evento'] != null) {
      galeriaEvento = new List<GaleriaEvento>();
      json['galeria_evento'].forEach((v) {
        galeriaEvento.add(new GaleriaEvento.fromJson(v));
      });
    }
  }

  Evento.withError(String errorValue) : error = true;
}

class GaleriaEvento {
  int eventoId;
  String titulo;
  String archivoFoto;

  GaleriaEvento({this.eventoId, this.titulo, this.archivoFoto});

  GaleriaEvento.fromJson(Map<String, dynamic> json) {
    eventoId = json['evento_id'];
    titulo = json['titulo'];
    archivoFoto = json['archivo_foto'];
  }
}
