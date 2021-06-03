import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/responses/academy_response.dart';

import 'package:rumbero/logic/provider/academy_provider.dart';

class AcademiasBloc {
  final AcademyProvider _academyRepository = AcademyProvider();

  final BehaviorSubject<AcademyResponse> _subject =
      BehaviorSubject<AcademyResponse>();

  BehaviorSubject<AcademyResponse> get subject => _subject;

  Future getData() async {
    AcademyResponse response = await _academyRepository.getData();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }
}

final academiasBloc = AcademiasBloc();
