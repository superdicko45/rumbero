
import 'redes_model.dart';
import 'category_model.dart';
import 'galeria_model.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

class User {
  int usuarioId;
  String username;
  String nombre;
  String fotoPerfil;
  String descripcion;
  String tipoUsuario;
  int seguidores;
  int seguidos;
  List<Redes> redes;
  List<Category> categorias;
  List<Galeria> galeria;
  List<EventModelResponse> eventos;
  bool uploadImg;
  bool error;

  User({
    this.usuarioId,
    this.username,
    this.nombre,
    this.fotoPerfil,
    this.descripcion,
    this.tipoUsuario,
    this.seguidores,
    this.seguidos,
    this.redes,
    this.categorias,
    this.galeria,
    this.eventos,
    this.uploadImg
  });

  User.fromJson(Map<String, dynamic> json) {
    usuarioId   = json['user']['usuario_id'];
    username    = json['user']['username'];
    nombre      = json['user']['nombre'];
    fotoPerfil  = json['user']['foto_perfil'];
    descripcion = json['user']['descripcion'];
    tipoUsuario = json['user']['tipo_usuario'];
    seguidores  = json['user']['seguidores'];
    seguidos    = json['user']['seguidos'];
    uploadImg   = json['user']['upload_img'] == 1 ? true : false;

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
    if (json['galeria']['data'] != null) {
      galeria = new List<Galeria>();
      json['galeria']['data'].forEach((v) {
        galeria.add(new Galeria.fromJson(v));
      });
    }
    if (json['eventos']['data'] != null) {
      eventos = new List<EventModelResponse>();
      json['eventos']['data'].forEach((v) {
        eventos.add(new EventModelResponse.fromJson(v));
      });
    }
  }

  User.withError(String errorValue) : error = true;
}