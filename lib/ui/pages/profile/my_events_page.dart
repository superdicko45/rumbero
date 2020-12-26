import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/profile/events_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/search/event_widget.dart';

class MyEventspage extends StatefulWidget {
  MyEventspage({Key key}) : super(key: key);

  @override
  _MyEventspageState createState() => _MyEventspageState();
}

class _MyEventspageState extends State<MyEventspage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final EventsBloc _eventsBloc = new EventsBloc();

  @override
  void initState() {
    super.initState();
    _eventsBloc.getEvents();
  }

  @override
  void dispose() {
    super.dispose();
    _eventsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Mis eventos'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: StreamBuilder<bool>(
        stream: _eventsBloc.isLoadingController.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if(
                      !snapshot.data &&
                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      scrollInfo is ScrollEndNotification
                    )
                      _eventsBloc.loadMore();

                    return true;
                  },
                  child: _body()
                )  
              ),
              Container(
                height: snapshot.data ? 50.0 : 0,
                child: _loader()
              ),
            ],
          );
        }
      ),
    );
  }

  void _delete(String _evento, int _eventoId) async{
        
    _eventsBloc.delEvento(_eventoId);

    var _snackBar = SnackBar(
      content: Text('Se eliminó: "$_evento"')
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Widget _empty() {
    
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(child: NoInfo(svg: 'events.svg', text: 'Tu lista esta vacia.',)),
      Expanded(
        child: Column(
          mainAxisAlignment: _orientation != Orientation.landscape 
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No dejes que eso te detenga, descubre más sociales.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            floatinButton()
          ],
        ),
      )
    ]; 
    
    return _orientation != Orientation.landscape 
      ? Column(
        children: _items,
      ) 
      : Row(
        children: _items,
      );
  }

  Widget floatinButton(){
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(Icons.search),
      label: Text('Buscar'),
      onPressed: () => Navigator.of(context).pushNamed('/results'), 
    );
  }

  Widget _body() {
    return StreamBuilder<List<EventModelResponse>>(
      stream: _eventsBloc.eventsController.stream,
      builder: (context, AsyncSnapshot<List<EventModelResponse>> snapshot) {
        
        if (snapshot.hasData){

          List<EventModelResponse> _eventos = snapshot.data;

          if(_eventos.length > 0)
            return ListView.builder(
              itemCount: _eventos.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return item(_eventos[index]);
              }
            );

          else
            return _empty();
        }
        
        else return _loader();
      }
    );
  }

  Widget _loader(){
    return Center(
      child: CircularProgressIndicator(),
    );  
  }

  Widget item(EventModelResponse evento) {
    return Dismissible(
      key: Key(evento.eventoId.toString()),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      onDismissed: (direction) {
        _delete(evento.titulo, evento.eventoId);
      },
      child: EventResult(evento: evento)
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Borrar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Borrar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

}