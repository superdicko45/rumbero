import 'package:rumbero/logic/entity/models/comentario_model.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/blog_provider.dart';

enum stateSignIn {WAITING, ENABLE, LOADING, UNSIGNIN}

class CommentBloc {

  final BlogProvider _blogRepository = BlogProvider();
  int page = 1;
  
  final BehaviorSubject<bool> _isLoadingSubject  = BehaviorSubject<bool>();
  final BehaviorSubject<String> _inputSubject  = BehaviorSubject<String>();
  final BehaviorSubject<stateSignIn> _stateTypeSubject  = BehaviorSubject<stateSignIn>();
  final BehaviorSubject<List<Comentario>> _commentSubject  = BehaviorSubject<List<Comentario>>();

  void tipyng(String input) {
    if(input.length == 0) _stateTypeSubject.sink.add(stateSignIn.WAITING);
    else _stateTypeSubject.sink.add(stateSignIn.ENABLE);

    _inputSubject.sink.add(input);
  }

  Future getComments(String blogId) async {
    List<Comentario> response = await _blogRepository.getComentarios(blogId, '1');
    _commentSubject.sink.add(response);
  }

  Future loadMore(String blogId) async {

    _isLoadingSubject.sink.add(true);
    
    page ++;

    List<Comentario> _actuales = _commentSubject.value;
    List<Comentario> response = await _blogRepository.getComentarios(blogId, page.toString());

    if(response.length > 0) {

      List<Comentario> _nuevos = response;

      _actuales.addAll(_nuevos);
      _commentSubject.sink.add(_actuales);
    }else{
      page --;
    }

    _isLoadingSubject.sink.add(false);
  }

  Future<bool> addComment(String blogId) async {

    _stateTypeSubject.sink.add(stateSignIn.LOADING);

    String comment = _inputSubject.value;
    Comentario _comment = await _blogRepository.addComentario(comment, blogId);

    if(_comment.createdAt == null) return false;

    List<Comentario> _actuales = _commentSubject.value;
    List<Comentario> _nuevos = List<Comentario>();

    _nuevos.add(_comment);
    _nuevos.addAll(_actuales);

    _commentSubject.sink.add(_nuevos);
    _stateTypeSubject.sink.add(stateSignIn.ENABLE);

    return true;
  }

  dispose() {
    _isLoadingSubject.close();
    _stateTypeSubject.close();
    _commentSubject.close();
    _inputSubject.close();
  } 

  BehaviorSubject<bool> get isLoadingController  => _isLoadingSubject;
  BehaviorSubject<stateSignIn> get stateTypeController  => _stateTypeSubject;
  BehaviorSubject<List<Comentario>> get commentController => _commentSubject;

}

final commentBloc = CommentBloc();