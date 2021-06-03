import 'package:intl/intl.dart';

class Search {
  final int tipo;
  final String colonia;
  final int ciudad;
  final double min;
  final double max;
  final List<int> categorias;
  final DateTime minD;
  final DateTime maxD;
  final bool filtro;
  final int tipoE;
  final bool week;
  final bool weekend;
  final bool online;
  String q;

  Search(
      {this.tipo,
      this.colonia,
      this.ciudad,
      this.min,
      this.max,
      this.categorias,
      this.minD,
      this.maxD,
      this.filtro,
      this.tipoE,
      this.week,
      this.weekend,
      this.online,
      this.q});

  String toString() {
    String query = '';

    if (this.q != null) query += "q=${this.q}&";
    if (this.tipo != null) query += "tipo=${this.tipo}&";
    if (this.colonia != null) query += "colonia=${this.colonia}&";
    if (this.ciudad != null) query += "ciudad=${this.ciudad}&";
    if (this.min != null) query += "costoMin=${this.min}&";
    if (this.max != null) query += "costoMax=${this.max}&";
    if (this.filtro != null) query += "filtro=${this.filtro ? 1 : 0}&";
    if (this.tipoE != null) query += "tipoE=${this.tipoE}&";
    if (this.week != null) query += "week=${this.week ? 1 : 0}&";
    if (this.weekend != null) query += "weekend=${this.weekend ? 1 : 0}&";
    if (this.online != null) query += "online=${this.online ? 1 : 0}&";

    if (this.minD != null) {
      DateFormat newFormat = new DateFormat("yyyy-MM-dd");
      query += "dateMin=${newFormat.format(this.minD)}&";
    }

    if (this.maxD != null) {
      DateFormat newFormat = new DateFormat("yyyy-MM-dd");
      query += "dateMax=${newFormat.format(this.maxD)}&";
    }

    if (this.categorias != null)
      categorias.forEach((cat) => query += "genero[]=$cat&");

    return query.substring(0, query.length - 1);
  }
}
