import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/profile/edit_provider.dart';
import 'package:rumbero/logic/provider/validator_provider.dart';
import 'package:rumbero/logic/entity/profile/my_user_model.dart';

enum stateType { WAITING, LOADING, SUCCESS, FAILURE }

class EditBloc with ValidatorProvider {
  final EditProvider _editProvider = EditProvider();

  final _userController = BehaviorSubject<MyUser>();
  final _nameController = BehaviorSubject<String>();
  final _nickController = BehaviorSubject<String>();
  final _descController = BehaviorSubject<String>();
  final _tipoController = BehaviorSubject<int>();
  final _cityController = BehaviorSubject<int>();
  final _geneController = BehaviorSubject<List<int>>();
  final _stateController = BehaviorSubject<stateType>();

  Stream<MyUser> get userStream => _userController;
  Stream<String> get nameStream => _nameController.transform(validarNombre);
  Stream<String> get descStream => _descController.transform(validarDesc);
  Stream<int> get tipoStream => _tipoController;
  Stream<int> get cityStream => _cityController;
  Stream<List<int>> get geneStream => _geneController;
  Stream<stateType> get stateStream => _stateController;

  Stream<String> get nickStream => _nickController
          .transform(validarNombre)
          .doOnData((String nickname) async {
        if (nickname.length > 5) {
          bool _response = await _editProvider.searchName(nickname);
          if (_response == true)
            _nickController.addError('Este nickname no esta disponible!');
        }
      });

  Future showUser() async {
    MyUser response = await _editProvider.showInfoUser();
    int ciudad = await _editProvider.getCurrentCity();

    _nameController.sink.add(response.nombre);
    _nickController.sink.add(response.username);
    _descController.sink.add(response.descripcion);
    _tipoController.sink.add(response.tipoUsuarioId);
    _cityController.sink.add(ciudad);
    _userController.sink.add(response);

    final List<int> _tempoCategorias = response.categorias.toList();

    _geneController.sink.add(_tempoCategorias);
  }

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeNick => _nickController.sink.add;
  Function(String) get changeDesc => _descController.sink.add;
  Function(int) get changeTipo => _tipoController.sink.add;
  Function(int) get changeCity => _cityController.sink.add;

  void changeGenero(int _new, bool value) {
    List<int> _newList = _geneController.value;

    if (value) //agrega
      _newList.add(_new);
    else //elimina
      _newList.remove(_new);

    _geneController.sink.add(_newList);
  }

  Stream<bool> get formValidStream =>
      Rx.combineLatest3(nameStream, descStream, nickStream, (a, b, c) => true);

  Future<Map<String, dynamic>> saveData() async {
    _stateController.sink.add(stateType.LOADING);

    List<int> _new = List<int>();
    List<int> _old = List<int>();
    List<int> _tempoActual = _userController.value.categorias;
    List<int> _tempoNuevo = _geneController.value;

    _tempoActual.forEach((element) {
      if (!_tempoNuevo.contains(element)) _old.add(element);
    });

    _tempoNuevo.forEach((element) {
      if (!_tempoActual.contains(element)) _new.add(element);
    });

    Map<String, dynamic> _response = await _editProvider.updateGeneral(
        _new,
        _old,
        _nameController.value,
        _nickController.value,
        _descController.value,
        _tipoController.value,
        _cityController.value);

    if (_response['error'])
      _stateController.sink.add(stateType.FAILURE);
    else
      _stateController.sink.add(stateType.SUCCESS);

    return _response;
  }

  dispose() {
    _nameController.close();
    _nickController.close();
    _descController.close();
    _tipoController.close();
    _geneController.close();
    _userController.close();
    _cityController.close();
    _stateController.close();
  }
}

final editBloc = EditBloc();
