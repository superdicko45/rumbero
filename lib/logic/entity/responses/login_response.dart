class LoginResponse{

  bool error;
  String errorMessage;
  String uid;
  String email;
  String displayName;
  String perfil;
}

class AuthResponse{

  bool error;
  int userId;
  String email;
  String nombre;
  String perfil;

  AuthResponse({this.error, this.userId, this.email, this.nombre});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    error  = false;
    userId = json['userId'];
    nombre = json['nombre'];
    email  = json['email'];
    perfil = json['perfil'];
  }

  AuthResponse.withError(String errorValue)
      : error = true;

}