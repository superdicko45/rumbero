class Blog {
  int blogId;
  String titulo;
  String imagen;
  String createdAt;
  String username;
  String fotoPerfil;
  bool error;
  List<Contenidos> contenidos;

  Blog(
      {this.blogId,
      this.titulo,
      this.imagen,
      this.createdAt,
      this.username,
      this.fotoPerfil,
      this.contenidos});

  Blog.fromJson(Map<String, dynamic> json) {
    blogId = json['blog']['blog_id'];
    titulo = json['blog']['titulo'];
    imagen = json['blog']['imagen'];
    createdAt = json['blog']['created_at'];
    username = json['blog']['username'];
    fotoPerfil = json['blog']['foto_perfil'];
    if (json['blog']['contenidos'] != null) {
      contenidos = new List<Contenidos>();
      json['blog']['contenidos'].forEach((v) {
        contenidos.add(new Contenidos.fromJson(v));
      });
    }
  }

  Blog.withError(String errorValue) : error = true;
}

class Contenidos {
  String titulo;
  String descripcion;
  String imagen;

  Contenidos({this.titulo, this.descripcion, this.imagen});

  Contenidos.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    imagen = json['imagen'];
  }

}
