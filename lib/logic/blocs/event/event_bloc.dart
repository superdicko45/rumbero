import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/events_provider.dart';
import 'package:rumbero/logic/entity/models/event_model.dart';

class EventBloc {
  final EventProvider _eventRepository = EventProvider();

  final BehaviorSubject<Evento> _eventSubject = BehaviorSubject<Evento>();
  final BehaviorSubject<bool> _rMoreSubject = BehaviorSubject<bool>();

  BehaviorSubject<Evento> get eventController => _eventSubject;
  BehaviorSubject<bool> get rMoreController => _rMoreSubject;

  Future changeRMore() async {
    bool actual = !_rMoreSubject.value;
    _rMoreSubject.sink.add(actual);
  }

  Future showEvent(String eventId) async {
    _eventSubject.sink.add(null);
    Evento response = await _eventRepository.showEvent(eventId);
    _eventSubject.sink.add(response);
    _rMoreSubject.sink.add(false);
  }

  dispose() {
    _rMoreSubject.close();
    _eventSubject.close();
  }
}

final eventBloc = EventBloc();
