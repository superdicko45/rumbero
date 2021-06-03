class Ticket {
  int folio;
  String user;
  String imagen;
  bool error;

  Ticket({this.imagen, this.folio, this.user});

  Ticket.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    folio = json['data']['usuario_evento_id'];
    user = json['data']['nombre'];
    imagen = json['data']['promocional'];
  }

  Ticket.withError(String errorValue) : error = true;
}
