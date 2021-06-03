class EnlaceModelResponse {
  String key;
  String url;
  String thumbnail;
  String name;

  EnlaceModelResponse({this.key, this.url, this.thumbnail, this.name});

  EnlaceModelResponse.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    url = json['url'];
    thumbnail = json['thumb'];
    name = json['name'];
  }
}
