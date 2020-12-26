import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/search/event_widget.dart';

import 'package:rumbero/logic/blocs/search/types/events_list_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';

class EventsListPage extends StatefulWidget {

  final dynamic params;

  const EventsListPage({Key key, this.params});

  @override
  _EventsListPageState createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  
  EventsListBloc _searchBloc = new EventsListBloc();

  @override
  void initState() {
    super.initState();
    _searchBloc.initLoad(widget.params);
  }

  @override
  void dispose() {
    super.dispose();
    _searchBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.loginGradientEnd,
        title: Text('Lista de eventos')
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<bool>(
      stream: _searchBloc.isLoadingStream,
      initialData: false,
      builder: (context, snapshot) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if(
              !snapshot.data &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              scrollInfo is ScrollEndNotification
            )
              _searchBloc.loadMore();

            return true;
          },
          child: StreamBuilder<List<EventModelResponse>>(
            stream: _searchBloc.eventsStream,
            builder: (context, snapshot){

              if (snapshot.hasData){

                List<EventModelResponse> _eventos = snapshot.data;

                if(_eventos.length > 0)
                  return ListView.builder(
                    itemCount: _eventos.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return EventResult(evento: _eventos[index]);
                    }
                  );

                else
                  return NoInfo(svg: 'events.svg', text: 'Sin resultados',);
              }
              
              else return _searching();

            },
          ),
        );
      }
    );
  
  }

  Widget _searching() {
    return Center(child: CircularProgressIndicator());
  }

}