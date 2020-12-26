import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/validator_provider.dart';

//import 'package:rumbero/logic/provider/login_provider.dart';

class RegisterBloc with ValidatorProvider{

  //final LoginProvider _loginProvider = LoginProvider();
  
  final _nameController  = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passController  = BehaviorSubject<String>();
  final _repsController  = BehaviorSubject<String>();


  Stream<String> get nameStream  => _nameController.transform( validarNombre );
  Stream<String> get emailStream => _emailController.transform( validarEmail );
  Stream<String> get passStream  => _passController.transform( validarLenght );
  Stream<String> get repsStream  => _repsController.transform( validarLenght )
    .doOnData((String confirmPassword){
      if(0 != _passController.value.compareTo(confirmPassword)) _repsController.addError("Passwords no coincide");      
    });

  Stream<bool> get formValidStream => Observable.combineLatest4(
    nameStream,  
    emailStream, 
    passStream, 
    repsStream,
    (a, b, c , d) => true
  );
  
  Function(String) get changeName  => _nameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass  => _passController.sink.add;
  Function(String) get changeReps  => _repsController.sink.add;

  String get name  => _nameController.value;
  String get email => _emailController.value;
  String get pass  => _passController.value;
  String get reps  => _repsController.value;
  
  dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
    _repsController.close();
  } 
}

final registerBloc = RegisterBloc();