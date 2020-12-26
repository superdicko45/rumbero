import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/repository/user_repository.dart';
import 'package:rumbero/logic/entity/models/show_user_model.dart';

class UserBloc {

  final UserRepository _userRepository = UserRepository();
  
  final BehaviorSubject<User> _userSubject = BehaviorSubject<User>();

  Future showUser(String userId) async {
    User response = await _userRepository.showUser(userId);
    _userSubject.sink.add(response);
  }

  dispose() {
    _userSubject.close();
  } 

  BehaviorSubject<User> get subject => _userSubject;
}

final userBloc = UserBloc();