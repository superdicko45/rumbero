import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:rumbero/logic/provider/search_provider.dart';

enum stateType { TIPYNG, SEARCHING, RESULTS, WAITING }

class SearchBloc {
  SharedPreferences _prefs;
  final SearchProvider _searchProvider = SearchProvider();

  Search filtro;

  final _suggeController = BehaviorSubject<List<String>>();
  final _resultController = BehaviorSubject<SearchResponse>();
  final _stateController = BehaviorSubject<stateType>();
  final _histoController = BehaviorSubject<List<String>>();

  Stream<List<String>> get suggeStream => _suggeController;
  Stream<SearchResponse> get resultStream => _resultController;
  Stream<List<String>> get histoStream => _histoController;
  Stream<stateType> get stateStream => _stateController;

  Search getFilter(String q) {
    filtro.q = q;
    return filtro;
  }

  Future<void> initLoad(Search _filtro) async {
    if (_filtro != null && _filtro.filtro) {
      filtro = _filtro;
      await filtrar();
    } else {
      filtro = new Search();
      List<String> historial = new List<String>();

      _prefs = await SharedPreferences.getInstance();

      if (_prefs.containsKey('historial'))
        historial = _prefs.getStringList('historial');

      _histoController.sink.add(historial);
      _stateController.sink.add(stateType.WAITING);
    }
  }

  Future<void> clean() async => _stateController.sink.add(stateType.WAITING);

  Future<void> suggestions(String q) async {
    if (q.length >= 4) {
      _stateController.sink.add(stateType.TIPYNG);
      List<String> _response = await _searchProvider.getSuggestions(q);
      _suggeController.sink.add(_response);
    }
  }

  Future<void> search(String q) async {
    _stateController.sink.add(stateType.SEARCHING);
    filtro.q = q;
    SearchResponse _response = await _searchProvider.getResults(filtro);
    _resultController.sink.add(_response);
    _stateController.sink.add(stateType.RESULTS);

    if (q != null && q.isNotEmpty) addToHistory(q);
  }

  Future<void> filtrar() async {
    _stateController.sink.add(stateType.SEARCHING);
    SearchResponse _response = await _searchProvider.getResults(filtro);
    _resultController.sink.add(_response);
    _stateController.sink.add(stateType.RESULTS);
  }

  void addToHistory(String q) async {
    List<String> actuales = _histoController.value;

    if (!actuales.contains(q)) {
      actuales.insert(0, q);

      if (actuales.length > 20) actuales.sublist(0, 20);

      _prefs = await SharedPreferences.getInstance();
      _prefs.setStringList('historial', actuales);
    }
  }

  dispose() {
    _suggeController.close();
    _stateController.close();
    _histoController.close();
    _resultController.close();
  }
}

final searchBloc = SearchBloc();
