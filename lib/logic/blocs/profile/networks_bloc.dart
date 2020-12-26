import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/profile/edit_provider.dart';
import 'package:rumbero/logic/entity/model_reponses/redes_model_response.dart';
import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/models/redes_model.dart';

enum stateType{WAITING, LOADING, SUCCESS, FAILURE}

class NetworsBloc {

  EditProvider _editProvider = new EditProvider();

  List<int> _cash = new List<int>();

  final BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject<bool>();
  final BehaviorSubject<List<General>> _opcionesSubject = BehaviorSubject<List<General>>();
  final BehaviorSubject<List<Redes>> _networksSubject = BehaviorSubject<List<Redes>>();
  final BehaviorSubject<stateType> _stateSubject = BehaviorSubject<stateType>();

  Future getNetworks() async {

    RedesModelResponse _response = await _editProvider.getRedes(); 
    List<Redes> _redes = _response.redes;
    List<General> _opciones = _response.catalogo;

    _networksSubject.sink.add(_redes);
    _opcionesSubject.sink.add(_opciones);
  }

  //Se encarga de agregar un nuevo Row
  Future<void> addNet(String _id) async{

    List<Redes> _actuales = _networksSubject.value;
    _actuales.add( 
      new Redes(socialId: 1, redSocial: '', itemId: _id)
    );

    _networksSubject.sink.add(_actuales);
  }

  //Se encarga de eliminar un Row
  Future<void> delNet(dynamic _id) async{
    
    List<Redes> _actuales = _networksSubject.value;
    _actuales.removeWhere((element) => element.itemId == _id);

    //Si es un registro existente
    if(_id is int) _cash.add(_id);

    _networksSubject.sink.add(_actuales);
  }

  //Cada que se cambia el dropdown
  Future<void> changeType(dynamic _id, int _newType) async {

    List<Redes> _actuales = _networksSubject.value;
    int _index = _actuales.indexWhere((element) => element.itemId == _id);
    Redes _redActual = _actuales[_index];
    
    _redActual.socialId = _newType;
    _actuales[_index] = _redActual;

    _networksSubject.sink.add(_actuales);
  }

  //Cada que cambia el input 
  Future<void> changeInput(dynamic _id, String _newInput) async {

    List<Redes> _actuales = _networksSubject.value;
    int _index = _actuales.indexWhere((element) => element.itemId == _id);
    Redes _redActual = _actuales[_index];
    
    _redActual.url= _newInput;
    _actuales[_index] = _redActual;

    _networksSubject.sink.add(_actuales);
  }

  Future<bool> saveData() async{

    _stateSubject.sink.add(stateType.LOADING);

    List<Redes> _actuales = _networksSubject.value.where(
      (element) => element.itemId is int
    ).toList();

    List<Redes> _nuevos = _networksSubject.value.where(
      (element) => element.itemId is String
    ).toList();

    bool error = await _editProvider.updateRedes(
      _nuevos, 
      _actuales, 
      _cash
    );

    if(error) _stateSubject.sink.add(stateType.FAILURE);
    else _stateSubject.sink.add(stateType.SUCCESS);

    return error;
  }

  dispose() {
    _isLoadingSubject.close();
    _opcionesSubject.close();
    _networksSubject.close();
    _stateSubject.close();
  }

  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<List<Redes>> get networksController => _networksSubject;
  BehaviorSubject<List<General>> get opcionesController => _opcionesSubject;
  BehaviorSubject<stateType> get stateController => _stateSubject;
}

final networksBloc = NetworsBloc();