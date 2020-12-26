import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/model_reponses/settings_model_response.dart';
import 'package:rumbero/logic/provider/profile/security_provider.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

enum stateType{WAITING, LOADING, SUCCESS, FAILURE}

class SettingsBloc{

  SharedPreferences _prefs;
  SecurityProvider _securityProvider = SecurityProvider();

  final BehaviorSubject<SettingsModelResponse> _settingsSubject = BehaviorSubject<SettingsModelResponse>();
  final BehaviorSubject<bool> _showEventSubject = BehaviorSubject<bool>();
  final BehaviorSubject<stateType>_stateSubject = BehaviorSubject<stateType>();
  
  Future<void> changeShowEvent(value) async => _showEventSubject.sink.add(value);
  
  Stream<SettingsModelResponse> get settingsStream => _settingsSubject;
  Stream<stateType> get stateStream => _stateSubject;
  Stream<bool>      get showEStream => _showEventSubject;

  Future getSettings() async {
    
    SettingsModelResponse response = await _securityProvider.getSettings();
    _settingsSubject.sink.add(response);
    _showEventSubject.sink.add(response.muestraEventos);
  }

  Future<Map<String, dynamic>> saveData() async{

    _stateSubject.sink.add(stateType.LOADING);

    Map<dynamic, dynamic> data = {
      'muestra_eventos' : _showEventSubject.value ? 1 : 0
    };

    LoginResponse response = await _securityProvider.updateSettings(data);

    Map<String, dynamic> setResponse = {
      'error' : response.error,
      'msg'   : response.errorMessage
    };

    if(setResponse['error']) _stateSubject.sink.add(stateType.FAILURE);
    else _stateSubject.sink.add(stateType.SUCCESS);
    
    return setResponse;
  }

  Future<void> deleteHistory() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('historial')) _prefs.remove('historial');
  }

  dispose() {
    _stateSubject.close();
    _showEventSubject.close();
    _settingsSubject.close();
  } 

}

final settingsBloc = SettingsBloc();