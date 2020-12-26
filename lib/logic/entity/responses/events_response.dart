import 'package:rumbero/logic/entity/models/zone_model.dart';
import '../model_reponses/event_model_response.dart';

class EventResponse{
  List<EventModelResponse> recomendados;
  List<EventModelResponse> recientes;
  List<EventModelResponse> paraHoy;
  List<Zone> cercanos;
  bool error;

  EventResponse(
    this.recomendados,
    this.cercanos,
    this.paraHoy,
    this.recientes, 
    this.error
  );

  EventResponse.fromJson(Map<String, dynamic> json) {

    if(json['recomendados'] == null && json['cercanos'] == null && json['recientes'] == null && json['paraHoy'] == null) error = true;
    else error = false;

    if (json['recomendados'] != null) {
      recomendados = new List<EventModelResponse>();
      json['recomendados'].forEach((v) {
        recomendados.add(new EventModelResponse.fromJson(v));
      });
    }

    if (json['cercanos'] != null) {
      cercanos = new List<Zone>();
      json['cercanos'].forEach((v) {
        cercanos.add(new Zone.fromJson(v));
      });
    }

    if (json['paraHoy'] != null) {
      paraHoy = new List<EventModelResponse>();
      json['paraHoy'].forEach((v) {
        paraHoy.add(new EventModelResponse.fromJson(v));
      });
    }

    if (json['recientes'] != null) {
      recientes = new List<EventModelResponse>();
      json['recientes'].forEach((v) {
        recientes.add(new EventModelResponse.fromJson(v));
      });
    }

  }

  EventResponse.withError(String errorValue) { error = true;}
}