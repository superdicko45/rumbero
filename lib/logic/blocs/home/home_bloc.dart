import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/home_provider.dart';
import 'package:rumbero/logic/entity/responses/home_response.dart';

class HomeBloc {
  final HomeProvider _homeRepository = HomeProvider();

  final BehaviorSubject<HomeResponse> _subject =
      BehaviorSubject<HomeResponse>();

  Future<void> getData() async {
    HomeResponse response = await _homeRepository.getData();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<HomeResponse> get subject => _subject;
}

final homeBloc = HomeBloc();
