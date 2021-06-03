class VideoModelResponse {
  int key;
  String url;
  String thumbnail;
  String name;
  int plays;

  VideoModelResponse(
      {this.key, this.url, this.thumbnail, this.name, this.plays});

  VideoModelResponse.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    url = json['url'];
    thumbnail = json['thumb'];
    name = json['name'];
    plays = json['reproducciones'];
  }
}
