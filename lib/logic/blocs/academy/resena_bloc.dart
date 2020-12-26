import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/academy_provider.dart';

import 'package:rumbero/logic/entity/models/academy_model.dart';
import 'package:rumbero/logic/entity/models/resena_model.dart';

class ResenaBloc {

  final AcademyProvider _academyRepository = AcademyProvider();

  int page = 1;
  String resena = '';

  final BehaviorSubject<Academia> _academiaSubject = BehaviorSubject<Academia>();
  final BehaviorSubject<bool> _isLoadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _showAddButtongSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<double> _starsSubject  = BehaviorSubject<double>();
  final BehaviorSubject<List<Resena>> _resenaSubject  = BehaviorSubject<List<Resena>>();

  BehaviorSubject<Academia> get academiaController => _academiaSubject;
  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<bool> get showAddButtonController  => _showAddButtongSubject;
  BehaviorSubject<double> get iResenaController  => _starsSubject;
  BehaviorSubject<List<Resena>> get resenasController => _resenaSubject;

  Function(double) get changeStars  => _starsSubject.sink.add;
  Function(String) changeResena(value) => resena = value;  

  Future<void> initLoad(Academia academia) async {
    academiaController.sink.add(academia);
    resenasController.sink.add(academia.resenas);
  }

  Future loadMore() async {

    int academyId = academiaController.value.academiasId;
    _isLoadingSubject.sink.add(true);
    
    page ++;

    List<Resena> _actuales = _resenaSubject.value;
    List<Resena> _response = await _academyRepository.getResena(academyId, page);

    if(_response.length > 0) {

      if(_actuales.length == 0) _actuales = new List<Resena>();

      _response.forEach((element) => _actuales.add(element) );

      _resenaSubject.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingSubject.sink.add(false);
  }

  Future saveRating() async {

    isLoadingController.sink.add(true);

    int academyId = academiaController.value.academiasId;
    int calificacion = _starsSubject.value == null ? 5 : _starsSubject.value.toInt();

    Academia _academia = await _academyRepository.addResena(
      resena, 
      academyId, 
      calificacion,
    );

    academiaController.sink.add(_academia);
    _resenaSubject.sink.add(_academia.resenas);
    
    showAddButtonController.sink.add(false);
    isLoadingController.sink.add(false);
  }

  dispose() {
    _academiaSubject.close();
    _resenaSubject.close();
    _isLoadingSubject.close();
    _starsSubject.close();
    _showAddButtongSubject.close();
  }

}

final resenaBloc = ResenaBloc();