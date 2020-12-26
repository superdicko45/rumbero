class Redes {
  String redSocial;
  String url;
  int socialId;
  dynamic itemId;
  String fullUrl;

  Redes({this.redSocial, this.url, this.itemId, this.socialId, this.fullUrl});

  Redes.fromJson(Map<String, dynamic> json) {
    redSocial = json['red_social'];
    url       = json['url'];
    socialId  = json['socialId'];
    itemId    = json['itemId'];
    fullUrl   = json['fullUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['red_social'] = this.redSocial;
    data['itemId'] = this.itemId;
    data['socialId'] = this.socialId;
    data['url'] = this.url;
    return data;
  }
  
}
