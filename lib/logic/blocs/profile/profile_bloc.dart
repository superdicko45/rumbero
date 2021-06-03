import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/provider/user_provider.dart';

class ProfileBloc{

  ProfileBloc(){ initState(); } // constructor

  final UserProvider _userRepository = UserProvider();
  SharedPreferences _prefs;

  final _usIdController = BehaviorSubject<int>();
  final _nameController = BehaviorSubject<String>();
  final _mailController = BehaviorSubject<String>();
  final _perfilController = BehaviorSubject<String>();
  final _uploadController = BehaviorSubject<bool>();


  Stream<String> get nameStream  => _nameController;
  Stream<String> get mailStream  => _mailController;
  Stream<String> get perfilStream  => _perfilController;
  Stream<bool>   get upldStream  => _uploadController;
  
  String get usIdStream  => _usIdController.value.toString();
  String get usNaStream  => _nameController.value.toString();
  String get usImStream  => _perfilController.value.toString();

  Future<void> initState() async {

    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {

      int    krumbero  = _prefs.getInt('keyRumbero');
      String fullName  = _prefs.getString('fullName'); 
      String email     = _prefs.getString('email'); 
      String perfil    = _prefs.getString('perfil'); 

      _usIdController.sink.add(krumbero);
      _nameController.sink.add(fullName);
      _mailController.sink.add(email);
      _perfilController.sink.add(perfil);
    } 
  }

  Future<void> uploadImgPtofile(List<Asset> newGaley) async {
    
    _uploadController.sink.add(true);

    List<ByteData> byteDataList = await Future.wait(newGaley.map((Asset image) => image.getByteData()));
    String newUrlImage = await _userRepository.updateImgProfile(_usIdController.value ,byteDataList);

    _perfilController.sink.add(newUrlImage);
    _prefs.setString('perfil', newUrlImage); 

    _uploadController.sink.add(false);
  }

  dispose() {
    _nameController.close();
    _mailController.close();
    _usIdController.close();
    _perfilController.close();
    _uploadController.close();
  } 
}

final profileBloc = ProfileBloc();