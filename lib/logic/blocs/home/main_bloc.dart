import 'package:rxdart/rxdart.dart';

class MainBloc {
  
  final BehaviorSubject<int> _indexSubject = BehaviorSubject<int>();

  BehaviorSubject<int> get indexController => _indexSubject;

  Function(int) get changeIndex => _indexSubject.sink.add;

  dispose() {
    _indexSubject.close();
  }

}

final mainBloc = MainBloc();