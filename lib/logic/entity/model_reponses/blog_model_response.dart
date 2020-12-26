class BlogModelResponse {
  int blogId;
  String titulo;
  String imagen;
  String createdAt;
  String username;
  String fotoPerfil;
  int total;

  BlogModelResponse(
      {this.blogId,
      this.titulo,
      this.imagen,
      this.createdAt,
      this.username,
      this.fotoPerfil,
      this.total});

  BlogModelResponse.fromJson(Map<String, dynamic> json) {
    blogId = json['blog_id'];
    titulo = json['titulo'];
    imagen = json['imagen'];
    createdAt = json['created_at'];
    username = json['username'];
    fotoPerfil = json['foto_perfil'];
    total = json['total'];
  }
}