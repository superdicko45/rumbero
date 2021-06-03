import 'package:flutter/material.dart';

import 'package:rumbero/logic/blocs/home/events_bloc.dart';
import 'package:rumbero/logic/entity/models/zone_model.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/responses/events_response.dart';

import 'package:rumbero/ui/widgets/card_slider_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/zone_slider_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  EventsBloc eventsBloc = new EventsBloc();

  @override
  void initState() {
    super.initState();
    eventsBloc.getEventos();
  }

  @override
  void dispose() {
    eventsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body(context);
  }

  @override
  bool get wantKeepAlive => true;

  Widget _cercanos(List<Zone> zonas) {
    return zonas.isNotEmpty ? ZoneSlider(zonas: zonas) : _emptyText();
  }

  Widget _recientes(List<EventModelResponse> eventos) {
    return eventos.isNotEmpty ? CardSlider(events: eventos) : _emptyText();
  }

  Widget _paraHoy(List<EventModelResponse> eventos) {
    return eventos.isNotEmpty ? CardSlider(events: eventos) : _emptyText();
  }

  Widget _recomendados(List<EventModelResponse> eventos) {
    return eventos.isNotEmpty ? CardSlider(events: eventos) : _emptyText();
  }

  Widget _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _body(context) {
    return RefreshIndicator(
      onRefresh: eventsBloc.getEventos,
      child: StreamBuilder<EventResponse>(
          stream: eventsBloc.subject.stream,
          builder: (context, snapshot) {
            return snapshot.hasData ? _main(snapshot.data) : _loader();
          }),
    );
  }

  Widget _main(EventResponse eventResponse) {
    return !eventResponse.error
        ? ListView(
            children: <Widget>[
              _header('Nuestra recomendación!'),
              _recomendados(eventResponse.recomendados),
              _header('Para el día de hoy!'),
              _paraHoy(eventResponse.paraHoy),
              _header('Agregados recientemente!'),
              _recientes(eventResponse.recientes),
              _header('Cerca de tu zona'),
              _cercanos(eventResponse.cercanos),
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
