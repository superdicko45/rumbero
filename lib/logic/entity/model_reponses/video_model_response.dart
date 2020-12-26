class VideoModelResponse {
  String key;
  String url;
  String thumbnail;
  String name;
  
  VideoModelResponse({this.key, this.url, this.thumbnail, this.name});

  VideoModelResponse.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    url = json['url'];
    thumbnail = json['thumb'];
    name = json['name'];
  }
}