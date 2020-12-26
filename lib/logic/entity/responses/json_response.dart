class JsonResponse{

  bool error;
  String data;

  JsonResponse({this.error, this.data});

  JsonResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'];
  }

  JsonResponse.withError(String errorValue)
      : data = 'Intenta despues!',
        error = true;

}