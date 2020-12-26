import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/provider/user_provider.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';

class GaleryBloc {

  final UserProvider _userRepository = UserProvider();
  SharedPreferences _prefs;
  int page = 1;

  final BehaviorSubject<bool> _canUploadSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _isLoadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _isUploadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<List<Galeria>> _galeriaSubject  = BehaviorSubject<List<Galeria>>();

  BehaviorSubject<bool> get canUploadController  => _canUploadSubject;
  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<bool> get isUploadingController  => _isUploadingSubject;
  BehaviorSubject<List<Galeria>> get galeriaController => _galeriaSubject;

  Future<void> initLoad(List<Galeria> _galery, int userId, bool uploadImg) async {

    _galeriaSubject.sink.add(_galery);
    _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey('isLoggedIn')) {

      int krumbero  = _prefs.getInt('keyRumbero');

      if(userId == krumbero && uploadImg) _canUploadSubject.sink.add(true);
    }
  } 
  
  Future loadMore(int userId) async {

    _isLoadingSubject.sink.add(true);
    
    page ++;

    List<Galeria> _actuales = _galeriaSubject.value;
    List<Galeria> _response = await _userRepository.getGalery(userId, page);

    if(_response.length > 0) {

      if(_actuales.length == 0) _actuales = new List<Galeria>();

      _response.forEach((element) => _actuales.add(element) );

      _galeriaSubject.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingSubject.sink.add(false);
  }


  Future<void> uploadGalery(int userId, List<Asset> newGaley) async {
    
    _isUploadingSubject.sink.add(true);

    List<ByteData> byteDataList = await Future.wait(newGaley.map((Asset image) => image.getByteData()));
    bool _response = await _userRepository.updateGalery(userId ,byteDataList);
    
    if(_response){
      
      page = 1;
      List<Galeria> _response = await _userRepository.getGalery(userId, page);

      _galeriaSubject.sink.add(_response);
    }

    _isUploadingSubject.sink.add(false);
  }

  dispose() {
    _galeriaSubject.close();
    _isLoadingSubject.close();
    _isUploadingSubject.close();
    _canUploadSubject.close();
  }

}

final galeryBloc = GaleryBloc();