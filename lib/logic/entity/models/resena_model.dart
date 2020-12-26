class Resena {
  String resena;
  String createdAt;
  int calificacion;
  String username;
  String fotoPerfil;

  Resena(
      {this.resena,
      this.createdAt,
      this.calificacion,
      this.username,
      this.fotoPerfil});

  Resena.fromJson(Map<String, dynamic> json) {
    resena = json['resena'];
    createdAt = json['created_at'];
    calificacion = json['calificacion'];
    username = json['username'];
    fotoPerfil = json['foto_perfil'];
  }
}