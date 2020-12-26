import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/academy_provider.dart';

import 'package:rumbero/logic/entity/models/galeria_model.dart';

class GaleryBloc {

  final AcademyProvider _academyRepository = AcademyProvider();

  int page = 1;

  final BehaviorSubject<bool> _isLoadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<List<Galeria>> _galeriaSubject  = BehaviorSubject<List<Galeria>>();

  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<List<Galeria>> get galeriaController => _galeriaSubject;

  Function(List<Galeria>) get initLoad  => _galeriaSubject.sink.add;
  
  Future loadMore(int academyId) async {

    _isLoadingSubject.sink.add(true);
    
    page ++;

    List<Galeria> _actuales = _galeriaSubject.value;
    List<Galeria> _response = await _academyRepository.getGalery(academyId, page);

    if(_response.length > 0) {

      if(_actuales.length == 0) _actuales = new List<Galeria>();

      _response.forEach((element) => _actuales.add(element) );

      _galeriaSubject.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingSubject.sink.add(false);
  }

  dispose() {
    _galeriaSubject.close();
    _isLoadingSubject.close();
  }

}

final galeryBloc = GaleryBloc();