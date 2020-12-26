import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/responses/events_response.dart';

import 'package:rumbero/logic/provider/events_provider.dart';

class EventsBloc {

  final EventProvider _eventRepository = EventProvider();  

  final BehaviorSubject<EventResponse> _mainSubject = BehaviorSubject<EventResponse>();

  BehaviorSubject<EventResponse> get subject   => _mainSubject;   

  Future<void> getEventos() async {
    EventResponse response = await _eventRepository.getMain('1');
    _mainSubject.sink.add(response);
  }
  
  dispose() {
    _mainSubject.close();
  }

}

final eventsBloc = EventsBloc();