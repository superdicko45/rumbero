import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

class LoginProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<LoginResponse> handleFacebookSignIn() async {
    LoginResponse _response = new LoginResponse();
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    if (result.status != FacebookLoginStatus.loggedIn) return null;

    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken.token);

    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      _response.error = false;
      _response.uid = result.user.uid;
      _response.displayName = result.user.displayName;
      _response.email = result.user.email;
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> handleSignIn(String email, String pass) async {
    LoginResponse _response = new LoginResponse();

    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      _response.error = false;
      _response.uid = result.user.uid;
      _response.displayName = result.user.displayName;
      _response.email = result.user.email;
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> handleGoogleSignIn() async {
    LoginResponse _response = new LoginResponse();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      _response.error = false;
      _response.uid = result.user.uid;
      _response.displayName = result.user.displayName;
      _response.email = result.user.email;
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> handleSignUp(
      String email, String pass, String name) async {
    LoginResponse _response = new LoginResponse();

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      _response.error = false;
      _response.uid = result.user.uid;
      _response.displayName = name;
      _response.email = email;
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> resetPass(String email) async {
    LoginResponse _response = new LoginResponse();

    try {
      _auth.sendPasswordResetEmail(email: email);
      _response.error = false;
      _response.errorMessage =
          "Se envió un email, sigue los pasos para recuperar tu contraseña.";
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  Future<LoginResponse> currentUser() async {
    LoginResponse _response = new LoginResponse();

    try {
      User result = _auth.currentUser;
      _response.error = false;
      _response.uid = result.uid;
      _response.displayName = result.displayName;
      _response.email = result.email;
    } catch (error) {
      _response.error = true;
      _response.errorMessage = getErrorMessage(error.code);
    }

    return _response;
  }

  //Logout de firebase
  void logout() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  //Regresa una traduccion de acuerdo al error
  String getErrorMessage(String error) {
    print(error);
    String errorMessage;

    switch (error) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Tu correo parece estar malformado.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Password incorrecto.";
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
      case "ERROR_NETWORK_REQUEST_FAILED":
        errorMessage = "Error de red.";
        break;
      default:
        errorMessage = "Un error inseperado ha ocurrido, intente más tarde.";
    }

    return errorMessage;
  }
}
