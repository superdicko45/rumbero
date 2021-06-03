import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/models/blog_model.dart';
import 'package:rumbero/logic/provider/blog_provider.dart';

class BlogBloc {
  final BlogProvider _blogRepository = BlogProvider();

  final BehaviorSubject<Blog> _blogSubject = BehaviorSubject<Blog>();

  BehaviorSubject<Blog> get blogController => _blogSubject;

  Future showBlog(String blogId) async {
    _blogSubject.sink.add(null);
    Blog response = await _blogRepository.showBlog(blogId);
    _blogSubject.sink.add(response);
  }

  dispose() => _blogSubject.close();
}

final blogBloc = BlogBloc();
