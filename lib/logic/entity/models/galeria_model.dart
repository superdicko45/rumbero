class Galeria {

  String galeriaId;
  String archivoFoto;

  Galeria({this.galeriaId, this.archivoFoto});

  Galeria.fromJson(Map<String, dynamic> json) {
    galeriaId = json['galeria_id'].toString();
    archivoFoto = json['archivo_foto'];
  }

}