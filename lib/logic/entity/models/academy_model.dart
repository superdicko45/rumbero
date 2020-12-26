import 'category_model.dart';
import 'galeria_model.dart';
import 'redes_model.dart';
import 'resena_model.dart';

class Academia {
  int academiasId;
  String nombre;
  String descripcion;
  String perfilImagen;
  String pagina;
  String telefono;
  String horario;
  String costos;
  String eslogan;
  int rangoMin;
  int rangoMax;
  String createdAt;
  String updateAt;
  int activo;
  String stars;
  int total;
  List<Redes> redes;
  List<Sucursales> sucursales;
  List<Galeria> galeria;
  List<Resena> resenas;
  Map<String, dynamic> raking;
  bool error;
  Promo promo;

  Academia({
    this.academiasId,
    this.nombre,
    this.descripcion,
    this.perfilImagen,
    this.pagina,
    this.telefono,
    this.horario,
    this.costos,
    this.eslogan,
    this.rangoMin,
    this.rangoMax,
    this.createdAt,
    this.updateAt,
    this.activo,
    this.stars,
    this.total,
    this.redes,
    this.promo,
    this.galeria,
    this.resenas,
    this.sucursales,
    this.raking
  });

  Academia.fromJson(Map<String, dynamic> json) {

    if(json['academia'] != null){
      academiasId  = json['academia']['academias_id'];
      nombre       = json['academia']['nombre'];
      descripcion  = json['academia']['descripcion'];
      perfilImagen = json['academia']['perfil_imagen'];
      pagina       = json['academia']['pagina'];
      telefono     = json['academia']['telefono'];
      horario      = json['academia']['horario'];
      costos       = json['academia']['costos'];
      eslogan      = json['academia']['eslogan'];
      rangoMin     = json['academia']['rango_min'];
      rangoMax     = json['academia']['rango_max'];
      createdAt    = json['academia']['created_at'];
      updateAt     = json['academia']['update_at'];
      activo       = json['academia']['activo'];
    }
    
    stars        = json['ranking']['stars'];
    total        = json['ranking']['total'];
    raking       = json['stars'];
    
    promo = json['promo'] != null ? new Promo.fromJson(json['promo']) : null;

    if (json['redes'] != null) {
      redes = new List<Redes>();
      json['redes'].forEach((v) {
        redes.add(new Redes.fromJson(v));
      });
    }

    if (json['sucursales'] != null) {
      sucursales = new List<Sucursales>();
      json['sucursales'].forEach((v) {
        sucursales.add(new Sucursales.fromJson(v));
      });
    }

    if (json['galeria'] != null && json['galeria']['data'] != null) {
      galeria = new List<Galeria>();
      json['galeria']['data'].forEach((v) {
        galeria.add(new Galeria.fromJson(v));
      });
    }

    if (json['comentarios']['data'] != null) {
      resenas = new List<Resena>();
      json['comentarios']['data'].forEach((v) {
        resenas.add(new Resena.fromJson(v));
      });
    }

  }

  Academia.withError() : error = true;  
}

class Sucursales {
  String ciudad;
  int sucursalId;
  int academiaId;
  String imagen;
  String sucursal;
  int ciudadId;
  String colonia;
  int online;
  int week;
  int weekend;
  String latitud;
  String longitud;
  int activo;
  List<Category> categorias;

  Sucursales({
    this.ciudad,
    this.sucursalId,
    this.academiaId,
    this.imagen,
    this.sucursal,
    this.ciudadId,
    this.colonia,
    this.online,
    this.week,
    this.weekend,
    this.latitud,
    this.longitud,
    this.activo,
    this.categorias
  });

  Sucursales.fromJson(Map<String, dynamic> json) {
    ciudad     = json['ciudad'];
    sucursalId = json['sucursal_id'];
    academiaId = json['academia_id'];
    imagen     = json['imagen'];
    sucursal   = json['sucursal'];
    ciudadId   = json['ciudad_id'];
    colonia    = json['colonia'];
    online     = json['online'];
    week       = json['week'];
    weekend    = json['weekend'];
    latitud    = json['latitud'];
    longitud   = json['longitud'];
    activo     = json['activo'];

    if (json['tags'] != null) {
      categorias = new List<Category>();
      json['tags'].forEach((v) {
        categorias.add(new Category.fromJson(v));
      });
    }
    
  }
}

class Promo {
  int promoId;
  String promo;

  Promo({this.promoId, this.promo});

  Promo.fromJson(Map<String, dynamic> json) {
    promoId = json['promo_id'];
    promo = json['promo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promo_id'] = this.promoId;
    data['promo'] = this.promo;
    return data;
  }
}