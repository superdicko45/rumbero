import '../models/general_model.dart';

class MyUser {
  int usuarioId;
  int tipoUsuarioId;
  String username;
  String nombre;
  String fotoPerfil;
  String descripcion;
  String tipoUsuario;
  List<int> categorias;
  List<General> catDisponibles; //categorias disponibles
  List<General> tipDisponibles; //tipos usuarios disponibles
  bool error;

  MyUser({
    this.usuarioId,
    this.tipoUsuarioId,
    this.username,
    this.nombre,
    this.fotoPerfil,
    this.descripcion,
    this.tipoUsuario,
    this.categorias
  });

  MyUser.fromJson(Map<String, dynamic> json) {

    usuarioId     = json['user']['usuario_id'];
    tipoUsuarioId = json['user']['tipo_usuario_id'];
    username      = json['user']['username'] != null ? json['user']['username'] : '';
    nombre        = json['user']['nombre'];
    fotoPerfil    = json['user']['foto_perfil'];
    descripcion   = json['user']['descripcion'];
    tipoUsuario   = json['user']['tipo_usuario'];
    
    if (json['generos'] != null) {
      categorias = new List<int>();
      json['generos'].forEach((v) {
        categorias.add(v);
      });
    }

    if (json['categorias'] != null) {
      catDisponibles = new List<General>();
      json['categorias'].forEach((v) {
        catDisponibles.add(new General.fromJson(v));
      });
    }

    if (json['tipos'] != null) {
      tipDisponibles = new List<General>();
      json['tipos'].forEach((v) {
        tipDisponibles.add(new General.fromJson(v));
      });
    }
    
  }

  MyUser.withError(String errorValue) : error = true;
}