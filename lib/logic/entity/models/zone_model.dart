class Zone {
  String ciudad;
  String colonia;
  int ciudadId;
  int total;

  Zone({this.ciudad, this.colonia, this.ciudadId, this.total});

  Zone.fromJson(Map<String, dynamic> json) {
    ciudad = json['ciudad'];
    colonia = json['colonia'];
    ciudadId = json['ciudad_id'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ciudad'] = this.ciudad;
    data['colonia'] = this.colonia;
    data['ciudad_id'] = this.ciudadId;
    data['total'] = this.total;
    return data;
  }
}