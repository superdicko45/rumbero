import 'package:rxdart/rxdart.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/models/ticket_model.dart';

import 'package:rumbero/logic/provider/events_provider.dart';

enum stateType { LOADING, UNSIGNIN, UNCHECKIN, SUCCESS }

class BottomSheetBloc {
  final EventProvider _eventRepository = EventProvider();
  SharedPreferences _prefs;

  final _stateController = BehaviorSubject<stateType>();

  Stream<stateType> get stateStream => _stateController;

  Future initoad(String eventId) async {
    _stateController.sink.add(stateType.LOADING);

    bool isLogin = await _isLogin();

    if (isLogin) {
      bool _haveTicket = await _eventRepository.checkEvent(eventId);

      if (_haveTicket)
        _stateController.sink.add(stateType.SUCCESS);
      else
        _stateController.sink.add(stateType.UNCHECKIN);
    } else
      _stateController.sink.add(stateType.UNSIGNIN);
  }

  Future getTicket(String eventId) async {
    _stateController.sink.add(stateType.LOADING);

    Ticket _ticket = await _eventRepository.addEvent(eventId);

    if (_ticket.error)
      _stateController.sink.add(stateType.UNCHECKIN);
    else
      _stateController.sink.add(stateType.SUCCESS);
  }

  Future<bool> _isLogin() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      return true;
    } else
      return false;
  }

  dispose() {
    _stateController.close();
  }
}

final bottomSheetBloc = BottomSheetBloc();
