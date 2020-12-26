import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/profile/security_provider.dart';
import 'package:rumbero/logic/provider/validator_provider.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

enum stateType{WAITING, LOADING, SUCCESS, FAILURE}

class ChangeEmailBloc with ValidatorProvider{

  SecurityProvider _securityProvider = SecurityProvider();

  final BehaviorSubject<String> _emailSubject  = BehaviorSubject<String>();
  final BehaviorSubject<stateType>_stateSubject = BehaviorSubject<stateType>();
  final BehaviorSubject<bool> _signSubject = BehaviorSubject<bool>();
  
  Function(String) get changeEmail => _emailSubject.sink.add;
  
  Stream<String>    get emailStream => _emailSubject.transform(validarEmail );
  Stream<stateType> get stateStream => _stateSubject;
  Stream<bool>      get signStream  => _signSubject;

  Future getEmail() async {
    
    String email = await _securityProvider.getEmail();
    _emailSubject.sink.add(email);
  }

  Future<Map<String, dynamic>> saveData() async{

    _stateSubject.sink.add(stateType.LOADING);

    String newEmail = _emailSubject.value;
    LoginResponse _lreponse = await _securityProvider.updateEmail(newEmail);
    
    //necesita logearse
    if(_lreponse.error && _lreponse.errorMessage == null) {
      _lreponse.errorMessage = 'Ocurrio un error!';
      _signSubject.sink.add(true);
    }

    Map<String, dynamic> response = {
      'error' : _lreponse.error,
      'msg'   : _lreponse.errorMessage
    };

    if(_lreponse.error) _stateSubject.sink.add(stateType.FAILURE);
    else _stateSubject.sink.add(stateType.SUCCESS);
    
    return response;
  }

  dispose() {
    _emailSubject.close();
    _stateSubject.close();
    _signSubject.close();
  } 

}

final changeEmailBloc = ChangeEmailBloc();