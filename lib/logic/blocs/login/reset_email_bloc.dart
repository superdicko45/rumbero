import 'package:rumbero/logic/entity/responses/login_response.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/login_provider.dart';
import 'package:rumbero/logic/provider/validator_provider.dart';

enum stateType { WAITING, LOADING, SUCCESS, FAILURE }

class ResetEmailBloc with ValidatorProvider {
  final LoginProvider _loginProvider = LoginProvider();
  final _emailController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<stateType>();

  Stream<String> get emailStream => _emailController.transform(validarEmail);
  Stream<stateType> get stateStream => _stateController;

  Function(String) get changeEmail => _emailController.sink.add;

  Future<LoginResponse> sendMail() async {
    _stateController.sink.add(stateType.LOADING);

    LoginResponse _response =
        await _loginProvider.resetPass(_emailController.value);

    if (_response.error)
      _stateController.sink.add(stateType.FAILURE);
    else
      _stateController.sink.add(stateType.SUCCESS);

    return _response;
  }

  dispose() {
    _emailController.close();
    _stateController.close();
  }
}

final resetEmailBloc = ResetEmailBloc();
