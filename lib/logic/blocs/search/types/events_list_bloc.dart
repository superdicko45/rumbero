import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/provider/search_provider.dart';

class EventsListBloc {

  final SearchProvider _searchProvider = SearchProvider();
  
  Search filtro;
  int page = 1;
  
  final _resultController = BehaviorSubject<SearchResponse>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _eventsController = BehaviorSubject<List<EventModelResponse>>();

  Stream<SearchResponse> get resultStream => _resultController;
  Stream<bool>           get isLoadingStream => _isLoadingController;
  Stream<List<EventModelResponse>> get eventsStream => _eventsController;

  Future<void> initLoad(dynamic _params) async {

      filtro = _params[1]; 
      List<EventModelResponse> eventos = _params[0];

      if(eventos.length == 0) {
        page = 0;
        loadMore();
      }
      else _eventsController.sink.add(eventos);
  }

  Future<void> search(String q) async {

    filtro.q = q;
    SearchResponse _response = await _searchProvider.getResults(filtro);
    _resultController.sink.add(_response);
  }

  Future<void> loadMore() async {

    _isLoadingController.sink.add(true);
    
    page ++;

    List<EventModelResponse> _actuales = _eventsController.value;
    List<EventModelResponse> response = await _searchProvider.getEventos(filtro, page.toString());

    if(response.length > 0) {

      if(_actuales == null) _actuales = new List<EventModelResponse>();

      _actuales.addAll(response);
      _eventsController.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingController.sink.add(false);
  }

  dispose() {
    _resultController.close();
    _isLoadingController.close();
    _eventsController.close();
  } 

}

final searchBloc = EventsListBloc();