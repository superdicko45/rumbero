import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/events_provider.dart';
import 'package:rumbero/logic/entity/models/ticket_model.dart';

class TicketBloc {
  final EventProvider _eventRepository = EventProvider();

  final BehaviorSubject<Ticket> _ticketSubject = BehaviorSubject<Ticket>();

  BehaviorSubject<Ticket> get ticketController => _ticketSubject;

  Future getTicket(String eventId, String userId) async {
    Ticket response = await _eventRepository.addEvent(eventId);
    _ticketSubject.sink.add(response);
  }

  dispose() {
    _ticketSubject.close();
  }
}

final ticketBloc = TicketBloc();
