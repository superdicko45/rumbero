import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/validator_provider.dart';

//import 'package:rumbero/logic/provider/login_provider.dart';

class LoginBloc with ValidatorProvider{

  //final LoginProvider _loginProvider = LoginProvider();
  
  final _emailController = BehaviorSubject<String>();
  final _passController  = BehaviorSubject<String>();


  Stream<String> get emailStream => _emailController.transform( validarEmail );
  Stream<String> get passStream  => _passController.transform( validarLenght );

  Stream<bool> get formValidStream => Observable.combineLatest2(emailStream, passStream, (a, b) => true);
  
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass  => _passController.sink.add;

  String get email => _emailController.value;
  String get pass  => _passController.value;
  
  dispose() {
    _emailController.close();
    _passController.close();
  } 
}

final loginBloc = LoginBloc();