import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';
import 'package:rumbero/logic/provider/search_provider.dart';

class UsersListBLoc {

  final SearchProvider _searchProvider = SearchProvider();
  
  Search filtro;
  int page = 1;
  
  final _resultController = BehaviorSubject<SearchResponse>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _usersController = BehaviorSubject<List<UserModelResponse>>();

  Stream<SearchResponse> get resultStream => _resultController;
  Stream<bool>           get isLoadingStream => _isLoadingController;
  Stream<List<UserModelResponse>> get usersTream => _usersController;

  Future<void> initLoad(dynamic _params) async {

      filtro = _params[1]; 
      List<UserModelResponse> users = _params[0];
      _usersController.sink.add(users);
  }

  Future<void> search(String q) async {

    filtro.q = q;
    SearchResponse _response = await _searchProvider.getResults(filtro);
    _resultController.sink.add(_response);
  }

  Future<void> loadMore() async {

    _isLoadingController.sink.add(true);
    
    page ++;

    List<UserModelResponse> _actuales = _usersController.value;
    List<UserModelResponse> response = await _searchProvider.getUsuarios(filtro, page.toString());

    if(response.length > 0) {

      _actuales.addAll(response);
      _usersController.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingController.sink.add(false);
  }

  dispose() {
    _resultController.close();
    _isLoadingController.close();
    _usersController.close();
  } 

}

final searchBloc = UsersListBLoc();