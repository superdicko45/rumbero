import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/provider/search_provider.dart';

class SchoolsListBloc {

  final SearchProvider _searchProvider = SearchProvider();
  
  Search filtro;
  int page = 1;
  
  final _resultController = BehaviorSubject<SearchResponse>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _schoolsController = BehaviorSubject<List<AcademyModelResponse>>();

  Stream<SearchResponse> get resultStream => _resultController;
  Stream<bool>           get isLoadingStream => _isLoadingController;
  Stream<List<AcademyModelResponse>> get schoolStream => _schoolsController;

  Future<void> initLoad(dynamic _params) async {

      filtro = _params[1]; 
      List<AcademyModelResponse> schools = _params[0];
      _schoolsController.sink.add(schools);
  }

  Future<void> loadMore() async {

    _isLoadingController.sink.add(true);
    
    page ++;

    List<AcademyModelResponse> _actuales = _schoolsController.value;
    List<AcademyModelResponse> response = await _searchProvider.getAcademias(filtro, page.toString());

    if(response.length > 0) {

      _actuales.addAll(response);
      _schoolsController.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingController.sink.add(false);
  }

  dispose() {
    _resultController.close();
    _isLoadingController.close();
    _schoolsController.close();
  } 

}

final searchBloc = SchoolsListBloc();