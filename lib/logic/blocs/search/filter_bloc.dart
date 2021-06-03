import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/search_provider.dart';

import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/models/search_model.dart';

class FilterBloc {
  final SearchProvider _searchProvider = SearchProvider();
  Search globalFilter;

  final _tipoController = BehaviorSubject<int>();
  final _ciudadController = BehaviorSubject<int>();
  final _rangeController = BehaviorSubject<List<double>>();
  final _minDController = BehaviorSubject<DateTime>();
  final _maxDController = BehaviorSubject<DateTime>();
  final _tipoEController = BehaviorSubject<int>();
  final _onlineController = BehaviorSubject<bool>();
  final _weekController = BehaviorSubject<bool>();
  final _weekendController = BehaviorSubject<bool>();
  final _generosController = BehaviorSubject<List<int>>();
  final _gDispController =
      BehaviorSubject<List<General>>(); // Generos disponibles
  final _cDispController =
      BehaviorSubject<List<General>>(); // ciudades disponibles

  Stream<int> get tipoStream => _tipoController;
  Stream<int> get ciudadStream => _ciudadController;
  Stream<List<double>> get rangeStream => _rangeController;
  Stream<DateTime> get minDStream => _minDController;
  Stream<DateTime> get maxDStream => _maxDController;
  Stream<int> get tipoEStream => _tipoEController;
  Stream<bool> get onlineStream => _onlineController;
  Stream<bool> get weekStream => _weekController;
  Stream<bool> get weekendStream => _weekendController;
  Stream<List<int>> get generosStream => _generosController;
  Stream<List<General>> get cDispStream => _cDispController;
  Stream<List<General>> get gDispStream => _gDispController;

  Future loadData(Search _filtro) async {
    globalFilter = _filtro;
    Map<String, dynamic> response = await _searchProvider.getData();

    final List<General> _categorias = response['categorias'];
    final List<General> _ciudades = response['ciudades'];
    final List<int> _actuales = new List<int>();

    _gDispController.sink.add(_categorias);
    _cDispController.sink.add(_ciudades);
    _generosController.sink.add(_actuales);

    if (_filtro != null) {
      if (_filtro.tipo != null) _tipoController.sink.add(_filtro.tipo);
      if (_filtro.ciudad != null) _ciudadController.sink.add(_filtro.ciudad);
      if (_filtro.minD != null) _minDController.sink.add(_filtro.minD);
      if (_filtro.maxD != null) _maxDController.sink.add(_filtro.maxD);
      if (_filtro.tipoE != null) _tipoEController.sink.add(_filtro.tipoE);
      if (_filtro.online != null) _onlineController.sink.add(_filtro.online);
      if (_filtro.week != null) _weekController.sink.add(_filtro.week);
      if (_filtro.weekend != null) _weekendController.sink.add(_filtro.weekend);

      if (_filtro.min != null && _filtro.max != null)
        _rangeController.sink.add([
          _filtro.min,
          _filtro.max,
        ]);

      if (_filtro.categorias != null)
        _generosController.sink.add(_filtro.categorias);
    }
  }

  Future<void> changeTipo(int v) async => _tipoController.sink.add(v);
  Future<void> changeCiudad(int v) async => _ciudadController.sink.add(v);
  Future<void> changeRan(List<double> v) async => _rangeController.sink.add(v);
  Future<void> changeMinD(DateTime v) async => _minDController.sink.add(v);
  Future<void> changeMaxD(DateTime v) async => _maxDController.sink.add(v);
  Future<void> changeTipoE(int v) async => _tipoEController.sink.add(v);
  Future<void> changeOnline(bool v) async => _onlineController.sink.add(v);
  Future<void> changeWeek(bool v) async => _weekController.sink.add(v);
  Future<void> changeWeekend(bool v) async => _weekendController.sink.add(v);

  void changeGenero(int _new, bool value) {
    List<int> _newList = _generosController.value;

    if (value) //agrega
      _newList.add(_new);
    else //elimina
      _newList.remove(_new);

    _generosController.sink.add(_newList);
  }

  Future<Search> filtrar() async {
    List<double> _rango = _rangeController.value;

    Search _filtro = new Search(
        tipo: _tipoController.value,
        ciudad: _ciudadController.value,
        min: _rango != null ? _rango[0] : null,
        max: _rango != null ? _rango[1] : null,
        categorias: _generosController.value,
        minD: _minDController.value,
        maxD: _maxDController.value,
        filtro: true,
        tipoE: _tipoEController.value,
        week: _weekController.value,
        weekend: _weekendController.value,
        online: _onlineController.value,
        q: globalFilter.q);
    return _filtro;
  }

  dispose() {
    _tipoController.close();
    _ciudadController.close();
    _rangeController.close();
    _minDController.close();
    _maxDController.close();
    _tipoEController.close();
    _onlineController.close();
    _weekController.close();
    _weekendController.close();
    _gDispController.close();
    _cDispController.close();
    _generosController.close();
  }
}

final filterBloc = FilterBloc();
