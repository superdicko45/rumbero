import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';

class AcademyResponse{
  List<AcademyModelResponse> recomendadas;
  List<AcademyModelResponse> rankeadas;
  List<AcademyModelResponse> paraHoy;
  bool error;

  AcademyResponse({
    this.recomendadas, 
    this.rankeadas,
    this.paraHoy,
    this.error
  });

  AcademyResponse.fromJson(Map<String, dynamic> json) {
    
    if(json['rankeadas'] == null && json['paraHoy'] == null && json['recomendadas'] == null) error = true;
    else error = false;

    if (json['rankeadas'] != null) {
      rankeadas = new List<AcademyModelResponse>();
      json['rankeadas'].forEach((v) {
        rankeadas.add(new AcademyModelResponse.fromJson(v));
      });
    }

    if (json['paraHoy'] != null) {
      paraHoy = new List<AcademyModelResponse>();
      json['paraHoy'].forEach((v) {
        paraHoy.add(new AcademyModelResponse.fromJson(v));
      });
    }

    if (json['recomendadas'] != null) {
      recomendadas = new List<AcademyModelResponse>();
      json['recomendadas'].forEach((v) {
        recomendadas.add(new AcademyModelResponse.fromJson(v));
      });
    }
  }

  AcademyResponse.withError(String errorValue) {
    error = true;
  }
}