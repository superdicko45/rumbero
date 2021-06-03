class Blog {
  int blogId;
  String titulo;
  String imagen;
  String createdAt;
  String resumen;
  String username;
  String fotoPerfil;
  bool error;
  List<Contenidos> contenidos;

  Blog(
      {this.blogId,
      this.titulo,
      this.imagen,
      this.createdAt,
      this.resumen,
      this.username,
      this.fotoPerfil,
      this.contenidos});

  Blog.fromJson(Map<String, dynamic> json) {
    error = false;
    blogId = json['blog']['blog_id'];
    titulo = json['blog']['titulo'];
    imagen = json['blog']['imagen'];
    resumen = json['blog']['resumen'];
    createdAt = json['blog']['created_at'];
    username = json['blog']['nombre'];
    fotoPerfil = json['blog']['foto_perfil'];
    if (json['contenidos'] != null) {
      contenidos = new List<Contenidos>();
      json['contenidos'].forEach((v) {
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
