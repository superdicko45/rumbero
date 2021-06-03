import 'package:rumbero/logic/entity/models/redes_model.dart';

class Marca {
  int marcaId;
  String marca;
  String imagen;
  String contacto;
  List<Redes> redes;
  List<int> tags;
  List<Articulo> articulos;

  Marca(
      {this.marcaId,
      this.marca,
      this.imagen,
      this.contacto,
      this.redes,
      this.tags,
      this.articulos});

  Marca.fromJson(Map<String, dynamic> json) {
    marcaId = json['marca_id'];
    marca = json['marca'];
    contacto = json['contacto'];
    imagen = json['imagen'];

    if (json['redes'] != null) {
      redes = new List<Redes>();
      json['redes'].forEach((v) {
        redes.add(new Redes.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = new List<int>();
      json['tags'].forEach((v) {
        tags.add(v['categoria_id']);
      });
    }
    if (json['articulos'] != null) {
      articulos = new List<Articulo>();
      json['articulos'].forEach((v) {
        articulos.add(new Articulo.fromJson(v));
      });
    }
  }
}

class Tags {
  String categoria;
  int id;

  Tags({this.categoria, this.id});

  Tags.fromJson(Map<String, dynamic> json) {
    categoria = json['categoria'];
    id = json['categoria_id'];
  }
}

class Articulo {
  int marcaId;
  String articulo;
  String imagen;
  int precio;

  Articulo({this.marcaId, this.articulo, this.imagen, this.precio});

  Articulo.fromJson(Map<String, dynamic> json) {
    marcaId = json['marca_id'];
    articulo = json['articulo'];
    imagen = json['imagen'];
    precio = json['precio'];
  }
}
