import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/profile/edit_provider.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

class EventsBloc {

  final EditProvider _editProvider = EditProvider();
  int page = 1;

  final BehaviorSubject<bool> _isLoadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<List<EventModelResponse>> _eventsSubject  = BehaviorSubject<List<EventModelResponse>>();

  Future getEvents() async {
    List<EventModelResponse> _eventos = await _editProvider.getEvents(1);
    _eventsSubject.sink.add(_eventos);
  }

  Future delEvento(int _eventoId) async {

    await _editProvider.delEvento(_eventoId);
    List<EventModelResponse> _eventos = eventsController.value;
    _eventos = _eventos.where((EventModelResponse evento) => evento.eventoId != _eventoId).toList();
    _eventsSubject.sink.add(_eventos);
  }

  Future loadMore() async {

    _isLoadingSubject.sink.add(true);
    
    page ++;

    List<EventModelResponse> _actuales = _eventsSubject.value;
    List<EventModelResponse> response = await _editProvider.getEvents(page);

    if(response.length > 0) {

      _actuales.addAll(response);
      _eventsSubject.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingSubject.sink.add(false);
  }

  dispose() {
    _eventsSubject.close();
    _isLoadingSubject.close();
  }

  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<List<EventModelResponse>> get eventsController => _eventsSubject;

}

final eventsBloc = EventsBloc();