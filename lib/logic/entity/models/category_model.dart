class Category {
  int generoId;
  String genero;
  String imagen;

  Category({this.generoId, this.genero, this.imagen});

  Category.fromJson(Map<String, dynamic> json) {
    generoId = json['genero_id'];
    genero = json['genero'];
    imagen = json['imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genero_id'] = this.generoId;
    data['genero'] = this.genero;
    data['imagen'] = this.imagen;
    return data;
  }
}
