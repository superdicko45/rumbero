import 'package:flutter/material.dart';

import 'package:rumbero/logic/blocs/home/academias_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/entity/responses/academy_response.dart';

import 'package:rumbero/ui/widgets/home/academias_slider_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class SchoolsPage extends StatefulWidget {
  const SchoolsPage({Key key}) : super(key: key);

  @override
  _SchoolsPageState createState() => _SchoolsPageState();
}

class _SchoolsPageState extends State<SchoolsPage>
    with AutomaticKeepAliveClientMixin {
  AcademiasBloc _academiasBloc = new AcademiasBloc();

  @override
  void initState() {
    super.initState();
    _academiasBloc.getData();
  }

  @override
  void dispose() {
    _academiasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body(context);
  }

  @override
  bool get wantKeepAlive => true;

  Widget _rankeadas(List<AcademyModelResponse> rankeadas) {
    return rankeadas.isNotEmpty
        ? AcademySlider(academias: rankeadas)
        : _emptyText();
  }

  Widget _paraHoy(List<AcademyModelResponse> paraHoy) {
    return paraHoy.isNotEmpty
        ? AcademySlider(academias: paraHoy)
        : _emptyText();
  }

  Widget _recomendados(List<AcademyModelResponse> recomendadas) {
    return recomendadas.isNotEmpty
        ? AcademySlider(academias: recomendadas)
        : _emptyText();
  }

  Widget _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _body(context) {
    return RefreshIndicator(
      onRefresh: _academiasBloc.getData,
      child: StreamBuilder<AcademyResponse>(
          stream: _academiasBloc.subject.stream,
          builder: (context, snapshot) {
            return snapshot.hasData ? _main(snapshot.data) : _loader();
          }),
    );
  }

  Widget _main(AcademyResponse academyResponse) {
    return !academyResponse.error
        ? ListView(
            children: <Widget>[
              _header('Nuestra recomendación!'),
              _recomendados(academyResponse.recomendadas),
              _header('Top evaluadas!'),
              _rankeadas(academyResponse.recomendadas),
              _header('Para tomar clase hoy!'),
              _paraHoy(academyResponse.paraHoy),
              SizedBox(
                height: 10,
              )
            ],
          )
        : _empty();
  }

  Widget _empty() {
    return Center(
      child: NoInfo(
        svg: 'events.svg',
        text: 'Algo sucedio',
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: new TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }

  Widget _emptyText() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sin resultados, intenta volver a recargar!',
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }
}
