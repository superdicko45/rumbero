import 'package:rumbero/logic/entity/responses/marcas_response.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rumbero/logic/entity/models/marca_model.dart';

import 'package:rumbero/logic/provider/marcas_provider.dart';

class MarcasBloc {
  final MarcaProvider _marcasRepository = MarcaProvider();

  List<Marca> allBrands = new List<Marca>();

  final BehaviorSubject<MarcasResponse> _mainSubject =
      BehaviorSubject<MarcasResponse>();

  final BehaviorSubject<List<Marca>> _marcasSubject =
      BehaviorSubject<List<Marca>>();

  final BehaviorSubject<int> _selectedSubject = BehaviorSubject<int>();

  BehaviorSubject<List<Marca>> get marcasSubject => _marcasSubject;
  BehaviorSubject<int> get selectedSubject => _selectedSubject;
  BehaviorSubject<MarcasResponse> get mainSubject => _mainSubject;

  Future<void> getMarcas() async {
    MarcasResponse response = await _marcasRepository.getData();
    _mainSubject.sink.add(response);
    _marcasSubject.sink.add(response.marcas);
    allBrands = response.marcas;
  }

  Future<void> filter(int idTag) async {
    List<Marca> newLIst = List<Marca>();

    if (idTag == 0) {
      newLIst = allBrands;
    } else {
      allBrands.forEach((Marca marca) {
        if (marca.tags.contains(idTag)) newLIst.add(marca);
      });
    }
    _selectedSubject.sink.add(idTag);
    _marcasSubject.sink.add(newLIst);
  }

  dispose() {
    _mainSubject.close();
    _marcasSubject.close();
    _selectedSubject.close();
  }
}

final marcasBloc = MarcasBloc();
