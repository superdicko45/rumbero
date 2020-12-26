class UserModelResponse {
  int usuarioId;
  String nombre;
  String username;
  String fotoPerfil;
  String tipoUsuario;

  UserModelResponse({this.usuarioId, this.nombre, this.fotoPerfil, this.tipoUsuario, this.username});

  UserModelResponse.fromJson(Map<String, dynamic> json) {
    usuarioId = json['usuario_id'];
    nombre = json['nombre'];
    username = json['username'];
    fotoPerfil = json['foto_perfil'];
    tipoUsuario = json['tipo_usuario'];
  }
}