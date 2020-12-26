import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:rumbero/logic/blocs/event/event_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';
import 'package:rumbero/logic/entity/models/event_model.dart';
import 'package:rumbero/logic/entity/models/redes_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/chip_slider_widget.dart';
import 'package:rumbero/ui/widgets/hero_wrap_widget.dart';
import 'package:rumbero/ui/widgets/map_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';
import 'package:rumbero/ui/widgets/video_player_widget.dart';
import 'package:rumbero/ui/widgets/event/special_buttons_widget.dart';

class EventPage extends StatefulWidget {

  final dynamic params;

  const EventPage({
    @required this.params,
    Key key
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  EventBloc _eventBloc = new EventBloc();

  void initState() {
    super.initState();
    initialDate();
    _eventBloc.showEvent(widget.params[0]);
    _eventBloc.rMoreController;
  }

  @override
  void dispose(){
    _eventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: ListView(
        children: <Widget>[

          header(
            widget.params,
            _orientation != Orientation.landscape 
              ? _screenSize.height * .3 
              : _screenSize.height * .55,
            context   
          ),

          StreamBuilder<Evento>(
            stream: _eventBloc.eventController.stream,
            builder: (context, AsyncSnapshot<Evento> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.error
                  ? _empty()
                  : body(snapshot.data);
              }
              else 
                return Center(child: CircularProgressIndicator());
            }
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    
    return Center(
      child: NoInfo(svg: 'events.svg', text: 'Algo sucedio',),
    );
  }
  
  Future<void> initialDate() async{
    await initializeDateFormatting('es_ES');
  }

  Widget body(Evento evento) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Column(
      children: <Widget>[
        centerInfo(evento),
        description(evento.descripcion),
        maps(
          _orientation != Orientation.landscape 
            ? _screenSize.height * .3 
            : _screenSize.height * .55,
          double.parse(evento.latitud),
          double.parse(evento.longitud)  
        )
      ],
    );
  }

  Widget header(List<dynamic> params, double alto, context){

    String cover = params[4];

    return Stack(
      alignment: Alignment(.5, 1.0),
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Hero(
              tag: widget.params[1],
              child: FadeInImage(
                width: double.infinity,
                height: alto,
                image: NetworkImage(params[2]),
                placeholder: AssetImage('assets/img/tempo.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          height: alto,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.black26,
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Chip(
                    backgroundColor: Colors.redAccent,
                    label: Text(params[3], style: TextStyle(
                      color: Colors.white
                    )),
                  ),
                  Chip(
                    label: Text("\u{0024} $cover", style: TextStyle(color: Colors.white)),
                    backgroundColor: Theme.Colors.loginGradientStart,
                    elevation: 5.0,
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget centerInfo(Evento evento){

    String ciudad = evento.colonia + ', ' +evento.ciudad;

    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaInicio);
    var finalO  = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaFinal);
    var formatter = new DateFormat('EEE d MMMM  h:mm a', 'es_ES');
    
    String inicioD = formatter.format(inicioO);
    String finalD = formatter.format(finalO);

    return Column(
      children: <Widget>[

        evento.redes.length > 0 
          ? redes(evento.redes)
          : SizedBox(height: 20.0,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Inicia : ', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),),
            Text(inicioD, style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54
            ),),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Termina : ', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),),
            Text(finalD, style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0
            ),),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ciudad, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),),
          ],
        ),

        evento.categorias.length > 0 
          ? ChipSlider(categories: evento.categorias)
          : SizedBox(),

        buttons(evento.latitud, evento.longitud, evento.eventoId),

        evento.invitados.length > 0 
          ? avatars('Invitados Especiales', evento.invitados)
          : SizedBox(),

        evento.organizadores.length > 0 
          ? avatars('Organizadores', evento.organizadores)
          : Text('Sin Organizadores', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0
            )),
        evento.video != null
          ? youtube(evento.video)
          : SizedBox()
      ],
    );
  }

  Widget redes(List<Redes> redes) {
    return RedesWrap(redes: redes, showText: false,);
  }

  Widget avatars(String text, List<UserModelResponse> invitados){

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Text(text, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0
            ),
          ),
        ),
        HeroWrap(usuarios: invitados)
      ],
    );  
  }

  Widget buttons(String lat, String lon, int eventId){
    return SpecialButtons(lat: lat, lon: lon, eventId: eventId,);
  }

  Widget youtube(String url){
    return VPlayer(urlVideo: url);
  }

  Widget description(String text){

    return InkWell(
      onTap: () => _eventBloc.changeRMore(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
            colors: [
              Theme.Colors.loginGradientStart,
              Theme.Colors.loginGradientEnd
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: StreamBuilder<bool>(
          stream: _eventBloc.rMoreController.stream,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data) return notComprimed(text);
            else return comprimed(text);
          },
        ), 
      )
    );
  }

  Widget notComprimed(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 17
      )
    );
  }

  Widget comprimed(String text) {
    return Column(
      children: [
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 1.0,
            color: Colors.white54,
          ),
        ),
        Text(
          'Ver más.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70
          ),
        )
      ],
    );    
  }

  Widget maps(double height, double lan, double lon){
    //return Text('Mapita');
    return Map(lat: lan, lon: lon, alto : height);
  }
}