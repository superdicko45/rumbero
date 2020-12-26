import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/provider/user_provider.dart';
import 'package:rumbero/logic/provider/login_provider.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

enum loginType{GOOGLE, FACEBOOK, NORMAL, REGISTER}
enum stateType{WAITING, LOADING, SUCCESS, FAILURE}

class LoginRepository with ChangeNotifier{

  LoginProvider _loginProvider = LoginProvider();
  UserProvider  _userProvider = UserProvider();
  SharedPreferences _prefs;
  bool _login = false;
  stateType _state  = stateType.WAITING;
  LoginResponse _response;
  AuthResponse  _authResponse;

  LoginRepository(){ loginState(); } // constructor

  // envia el estado de la aplicacion {loggedin} => true or false
  Future<void> login(loginType type, {String email, String pass, String name}) async{

    //actualiza en modo cargando
    updateState(stateType.LOADING);

    switch (type) {
      case loginType.GOOGLE:
        _response = await _loginProvider.handleGoogleSignIn();
        break;
      case loginType.FACEBOOK:
        _response = await _loginProvider.handleFacebookSignIn();
        break; 
      case loginType.REGISTER:
        _response = await _loginProvider.handleSignUp(email, pass, name);
        break;    
      default:
        _response = await _loginProvider.handleSignIn(email, pass);
    }

    //Si no hubo algun error en login con firebase
    if(_response != null && !_response.error){

      //Se hara a peticion de login en rumbero
      _authResponse = await _userProvider.createUser(
        _response.uid, _response.displayName, _response.email
      );

      //Si no sucedio un error
      if(!_authResponse.error) {
        _state = stateType.SUCCESS;
        _login = true;
        _prefs.setBool('isLoggedIn', true);
        _prefs.setString('keyFirebase', _response.uid);
        _prefs.setInt('keyRumbero', _authResponse.userId);
        _prefs.setString('fullName', _authResponse.nombre); 
        _prefs.setString('perfil', _authResponse.perfil); 
        _prefs.setString('email', _authResponse.email);  
      }
      else{

        _response.errorMessage = 'Ocurrio un error, intente mas tarde!';
        _login = false;
        _prefs.clear();
        _state = stateType.FAILURE; 
      }
    } 
    else{
      _response = new LoginResponse();
      _response.error = true;
      _response.errorMessage = 'Ocurrio un error, intente mas tarde!';
      
      _state = stateType.FAILURE;
      _login = false;
      _prefs.remove('isLoggedIn');
      _prefs.remove('keyFirebase');
      _prefs.remove('keyRumbero');
      _prefs.remove('fullName'); 
      _prefs.remove('perfil'); 
      _prefs.remove('email');
    } 

    notifyListeners();
  }

  // resetea el password enviando un email
  Future<void> resetPass(String email) async {
    //actualiza en modo cargando
    updateState(stateType.LOADING);

    _response = await _loginProvider.resetPass(email);

    if(!_response.error) updateState(stateType.SUCCESS);
    else updateState(stateType.FAILURE);
  }

  // regresa el estado del usuario
  bool isLogin() => _login;

  // regresa el id del usuario
  int getUserId() => _prefs.getInt('keyRumbero');

  // regresa el model EventResponse
  LoginResponse getResponse() => _response;

  //regresa el stateType de la app
  stateType wichtState() => _state;

  //actualiza el stateType
  updateState(stateType newState) {

    _state = newState;
    notifyListeners();
  }

  // logout del sistema
  void logout() {

    _login = false;
    _state = stateType.WAITING;
    _prefs.clear();
    _loginProvider.logout();
    notifyListeners();
  }

  void loginState() async {

    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {

      _response = await _loginProvider.currentUser();
      _login = !_response.error;
      notifyListeners();
    } 
  }
}