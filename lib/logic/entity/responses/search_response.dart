import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

class SearchResponse{
  
  List<AcademyModelResponse> academias;
  List<EventModelResponse> eventos;
  List<UserModelResponse> usuarios;
  bool error;

  SearchResponse({
    this.academias, 
    this.eventos,
    this.usuarios,
    this.error
  });

  SearchResponse.fromJson(Map<String, dynamic> json) {
    
    error = json['error'];

    if(!error){

      if (json['data']['users'] != null) {
        usuarios = new List<UserModelResponse>();
        json['data']['users'].forEach((v) {
          usuarios.add(new UserModelResponse.fromJson(v));
        });
      }

      if (json['data']['schools'] != null) {
        academias = new List<AcademyModelResponse>();
        json['data']['schools'].forEach((v) {
          academias.add(new AcademyModelResponse.fromJson(v));
        });
      }

      if (json['data']['events'] != null) {
        eventos = new List<EventModelResponse>();
        json['data']['events'].forEach((v) {
          eventos.add(new EventModelResponse.fromJson(v));
        });
      }
    }

  }

  SearchResponse.withError()
      : academias = List(),
        error = true;
}