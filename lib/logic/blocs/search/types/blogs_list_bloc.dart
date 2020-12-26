import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';

import 'package:rumbero/logic/provider/search_provider.dart';

class BlogsListBloc {

  final SearchProvider _searchProvider = SearchProvider();
  
  int page = 0;
  
  final _isLoadingController = BehaviorSubject<bool>();
  final _blogsController = BehaviorSubject<List<BlogModelResponse>>();

  Stream<bool> get isLoadingStream => _isLoadingController;
  Stream<List<BlogModelResponse>> get blogsStream => _blogsController;

  Future<void> loadMore() async {
    
    _isLoadingController.sink.add(true);
    
    page ++;

    List<BlogModelResponse> _actuales = _blogsController.value;
    List<BlogModelResponse> response = await _searchProvider.getBlogs(page.toString());

    if(_actuales == null) _actuales = new List<BlogModelResponse>();

    if(response.length > 0) {

      _actuales.addAll(response);
      _blogsController.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingController.sink.add(false);
  }

  dispose() {
    _isLoadingController.close();
    _blogsController.close();
  } 

}

final searchBloc = BlogsListBloc();