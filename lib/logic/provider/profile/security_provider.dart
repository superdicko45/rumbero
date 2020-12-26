import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/responses/login_response.dart';
import 'package:rumbero/logic/entity/model_reponses/settings_model_response.dart';

class SecurityProvider
{

  static String url = "https://rumbero.live/api/security";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;

  Future<String> getEmail() async {

    String email = '';

    try {

      FirebaseUser _user = await _auth.currentUser();
      email = _user.email;

    }
    catch(error){
      email = 'mail@mail.com';
    }
    
    return email;  
  }

  Future<LoginResponse> updateEmail(String newEmail) async{
    
    LoginResponse _response = new LoginResponse();
    _response.error = true;

    try {

      FirebaseUser _user = await _auth.currentUser();

      try {

        await _user.updateEmail(newEmail);
      
        int _idUser = await _getIdUser();

        Map data = {'usuario_id'  : _idUser, 'email' : newEmail};

        String body = json.encode(data);

        final response = await http.post(
          '$url/updEmail',
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          _prefs = await SharedPreferences.getInstance();
          _prefs.setString('email', newEmail);
          _response.error = false;
          _response.errorMessage = 'Se actualizo tu info';
        }
        else 
          _response.errorMessage = getErrorMessage('ERROR');

      } catch (error) {
        _response.errorMessage = getErrorMessage(error.code);
      }
    } catch (error) {
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> updatePass(String apass, String npass) async {
    LoginResponse _response = new LoginResponse();
    _response.error = true;

    try {

      FirebaseUser _user = await _auth.currentUser();
      AuthCredential credential = EmailAuthProvider.getCredential(
        email: _user.email,
        password: apass,
      );

      try {

        await _user.reauthenticateWithCredential(credential);
        
        try {

          await _user.updatePassword(npass);
          _response.error = false;
          _response.errorMessage = 'Se actualizo tu info';

        } catch (error) {
          _response.errorMessage = getErrorMessage(error.code);
        }  
          
      } catch (error) {
        _response.errorMessage = getErrorMessage(error.code);
      }

    } catch (error) {
      _response.errorMessage = getErrorMessage(error.code);
    }  

    return _response;
  }

  Future<SettingsModelResponse> getSettings() async {

    int _idUser = await _getIdUser();
    Map    data = {'usuario_id' : _idUser};
    String body = json.encode(data);
    final error = "Exception occured: 500 stackTrace: Fetch user $url/settings - $_idUser";
    
    final response = await http.post(
      '$url/settings',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return SettingsModelResponse.fromJson(json.decode(response.body));
    }
    else {
      // Si esta respuesta no fue OK, lanza un error.
      print(error);
      return SettingsModelResponse.withError();
    }
  }

  Future<LoginResponse> updateSettings(Map data) async{
    
    LoginResponse _response = new LoginResponse();
    _response.error = true;
  
    int _idUser = await _getIdUser();

    data['usuario_id'] = _idUser;

    String body = json.encode(data);

    print(body);
    final response = await http.post(
      '$url/updSettings',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      _response.error = false;
      _response.errorMessage = 'Se actualizo tu info';
    }
    else 
      _response.errorMessage = 'Ocurrío un problema!';
    
    return _response;
  }

  Future<int> _getIdUser() async {

    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('keyRumbero');
  }

  //Regresa una traduccion de acuerdo al error
  String getErrorMessage(String error){

    print(error);
    String errorMessage;

    switch (error) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Tu correo parece estar malformado.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Credenciales inválidas";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "No hay registros de este usuario.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "Usuario inhabilitado.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Demasiadas peticiones. Intente más tarde.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Iniciar con email y password no esta permitido.";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Esta cuenta de email ya se encuentra en uso.";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Password no es lo suficiente seguro.";
        break;
      case "ERROR_REQUIRES_RECENT_LOGIN":
        errorMessage = null; //Se maneja aparte para redireccionar
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Operación no permitida.";
        break;  
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Esta cuenta de correo ya esta en uso.";
        break;
      default:
        errorMessage = "Un error inseperado ha ocurrido, intente más tarde.";
    }

    return errorMessage;
  }

}