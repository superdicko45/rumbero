import 'dart:async';
import 'package:rumbero/logic/provider/user_provider.dart';
import 'package:rumbero/logic/entity/models/show_user_model.dart';

class UserRepository {
  
  final UserProvider _userRepository = UserProvider();

  Future<User> showUser(String id) => _userRepository.showUser(id);

}