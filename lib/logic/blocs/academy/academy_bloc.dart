import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/provider/academy_provider.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';

class AcademyBloc {
  final AcademyProvider _academyRepository = AcademyProvider();

  final BehaviorSubject<Academia> _academySubject = BehaviorSubject<Academia>();
  final BehaviorSubject<bool> _rMoreSubject = BehaviorSubject<bool>();

  BehaviorSubject<Academia> get academyController => _academySubject;
  BehaviorSubject<bool> get rMoreController => _rMoreSubject;

  Future changeRMore() async {
    bool actual = !_rMoreSubject.value;
    _rMoreSubject.sink.add(actual);
  }

  Future showAcademy(String academytId) async {
    _academySubject.sink.add(null);
    Academia response = await _academyRepository.showAcademy(academytId);
    _academySubject.sink.add(response);
    _rMoreSubject.sink.add(false);
  }

  dispose() {
    _rMoreSubject.close();
    _academySubject.close();
  }
}

final academyBloc = AcademyBloc();
