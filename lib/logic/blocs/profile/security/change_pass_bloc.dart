import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/profile/security_provider.dart';
import 'package:rumbero/logic/provider/validator_provider.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

enum stateType { WAITING, LOADING, SUCCESS, FAILURE }

class ChangePassBloc with ValidatorProvider {
  SecurityProvider _securityProvider = SecurityProvider();

  final BehaviorSubject<String> _apassSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _npassSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _rpassSubject = BehaviorSubject<String>();
  final BehaviorSubject<stateType> _stateSubject = BehaviorSubject<stateType>();
  final BehaviorSubject<bool> _signSubject = BehaviorSubject<bool>();

  Stream<stateType> get stateStream => _stateSubject;
  Stream<bool> get signStream => _signSubject;
  Stream<String> get apassStream => _apassSubject.transform(validarLenght);
  Stream<String> get npassStream => _npassSubject.transform(validarLenght);
  Stream<String> get rpassStream =>
      _rpassSubject.transform(validarLenght).doOnData((String confirmPassword) {
        if (0 != _npassSubject.value.compareTo(confirmPassword))
          _rpassSubject.addError("Contraseñas no coinciden");
      });

  Stream<bool> get formValidStream => Rx.combineLatest3(
      apassStream, npassStream, rpassStream, (a, b, c) => true);

  Function(String) get changeAPass => _apassSubject.sink.add;
  Function(String) get changeNPass => _npassSubject.sink.add;
  Function(String) get changeRPass => _rpassSubject.sink.add;

  Future<Map<String, dynamic>> saveData() async {
    _stateSubject.sink.add(stateType.LOADING);

    String apass = _apassSubject.value;
    String npass = _npassSubject.value;

    LoginResponse _lreponse = await _securityProvider.updatePass(apass, npass);

    //necesita logearse
    if (_lreponse.error && _lreponse.errorMessage == null) {
      _lreponse.errorMessage = 'Ocurrio un error!';
      _signSubject.sink.add(true);
    }

    Map<String, dynamic> response = {
      'error': _lreponse.error,
      'msg': _lreponse.errorMessage
    };

    if (_lreponse.error)
      _stateSubject.sink.add(stateType.FAILURE);
    else
      _stateSubject.sink.add(stateType.SUCCESS);

    return response;
  }

  dispose() {
    _apassSubject.close();
    _npassSubject.close();
    _rpassSubject.close();
    _stateSubject.close();
    _signSubject.close();
  }
}

final changePassBloc = ChangePassBloc();
