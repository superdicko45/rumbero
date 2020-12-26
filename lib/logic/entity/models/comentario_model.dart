class Comentario {
  String comentario;
  String createdAt;
  String username;
  String fotoPerfil;

  Comentario(
      {this.comentario, this.createdAt, this.username, this.fotoPerfil});

  Comentario.fromJson(Map<String, dynamic> json) {
    comentario = json['comentario'];
    createdAt = json['created_at'];
    username = json['username'];
    fotoPerfil = json['foto_perfil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comentario'] = this.comentario;
    data['created_at'] = this.createdAt;
    data['username'] = this.username;
    data['foto_perfil'] = this.fotoPerfil;
    return data;
  }
}