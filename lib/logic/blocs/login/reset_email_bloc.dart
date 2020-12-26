import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/validator_provider.dart';

class ResetEmailBloc with ValidatorProvider{

  //final LoginProvider _loginProvider = LoginProvider();
  
  final _emailController = BehaviorSubject<String>();

  Stream<String> get emailStream => _emailController.transform( validarEmail );
  
  Function(String) get changeEmail => _emailController.sink.add;

  String get email => _emailController.value;
  
  dispose() {
    _emailController.close();
  } 
}

final resetEmailBloc = ResetEmailBloc();