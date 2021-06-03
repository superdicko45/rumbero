import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rumbero/logic/blocs/event/event_bloc.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';
import 'package:rumbero/logic/entity/models/event_model.dart';
import 'package:rumbero/logic/entity/models/redes_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/pages/image_page.dart';
import 'package:rumbero/ui/widgets/chip_slider_widget.dart';
import 'package:rumbero/ui/widgets/hero_wrap_widget.dart';
import 'package:rumbero/ui/widgets/map_widget.dart';
import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';
import 'package:rumbero/ui/widgets/video_player_widget.dart';
import 'package:rumbero/ui/widgets/bottom_sheet_event_widget.dart';

class EventPage extends StatefulWidget {
  final dynamic params;

  const EventPage({@required this.params, Key key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  EventBloc _eventBloc = new EventBloc();

  void initState() {
    super.initState();
    initialDate();
    _eventBloc.showEvent(widget.params[0]);
    _eventBloc.rMoreController;
  }

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: scaffoldKey,
      body: ListView(
        children: <Widget>[
          header(
              widget.params,
              _orientation != Orientation.landscape
                  ? _screenSize.height * .3
                  : _screenSize.height * .55,
              context),
          StreamBuilder<Evento>(
              stream: _eventBloc.eventController.stream,
              builder: (context, AsyncSnapshot<Evento> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.error ? _empty() : body(snapshot.data);
                } else
                  return Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  void _launchmap(String lat, String lon) async {
    final String googleMapsUrl = "comgooglemaps://?center=$lat,$lon";
    final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lon";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

  void bottomSheetMore(String eventId, context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      builder: (builder) {
        return BottomSheetEvent(
          eventId: eventId,
        );
      },
    );
  }

  void _launchContacto(String url) async {
    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

  Future<void> initialDate() async {
    await initializeDateFormatting('es_ES');
  }

  Widget _empty() {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                'assets/svg/events.svg',
                height: 200.0,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Ocurrió un problema al cargar el evento.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
                backgroundColor: Theme.Colors.loginGradientStart,
                icon: Icon(
                  Icons.autorenew,
                  color: Colors.white,
                ),
                label: Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _eventBloc.showEvent(widget.params[0]))
          ],
        )
      ],
    );
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
            double.parse(evento.longitud))
      ],
    );
  }

  Widget header(List<dynamic> params, double alto, context) {
    String cover = params[4];
    List<Galeria> galeria = [new Galeria(archivoFoto: params[2])];

    return Stack(
      alignment: Alignment(.5, 1.0),
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImagePage(
                        galeria: galeria,
                        index: 0,
                      ))),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
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
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Chip(
                    backgroundColor: Colors.redAccent,
                    label:
                        Text(params[3], style: TextStyle(color: Colors.white)),
                  ),
                  Chip(
                    label: Text("\u{0024} $cover",
                        style: TextStyle(color: Colors.white)),
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

  Widget centerInfo(Evento evento) {
    String ciudad = evento.colonia + ', ' + evento.ciudad;

    var inicioO =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaInicio);
    var finalO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(evento.fechaFinal);
    var formatter = new DateFormat('EEE d MMMM  h:mm a', 'es_ES');

    String inicioD = formatter.format(inicioO);
    String finalD = formatter.format(finalO);

    return Column(
      children: <Widget>[
        evento.redes.length > 0
            ? redes(evento.redes)
            : SizedBox(
                height: 20.0,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Inicia : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Text(
              inicioD,
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Termina : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            Text(
              finalD,
              style: TextStyle(color: Colors.black54, fontSize: 16.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ciudad,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                evento.direccion,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
            ),
          ],
        ),
        evento.categorias.length > 0
            ? ChipSlider(categories: evento.categorias)
            : SizedBox(),
        buttons(
            evento.latitud, evento.longitud, evento.eventoId, evento.contacto),
        evento.invitados.length > 0
            ? avatars('Invitados Especiales', evento.invitados)
            : SizedBox(),
        evento.organizadores.length > 0
            ? avatars('Organizadores', evento.organizadores)
            : Text('Sin Organizadores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        evento.video != null ? videoPlayer(evento.video) : SizedBox()
      ],
    );
  }

  Widget redes(List<Redes> redes) {
    return RedesWrap(
      redes: redes,
      showText: false,
    );
  }

  Widget avatars(String text, List<UserModelResponse> invitados) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        HeroWrap(usuarios: invitados)
      ],
    );
  }

  Widget buttons(String lat, String lon, int eventId, String contacto) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(top: 30, left: 80.0, right: 80.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.Colors.loginGradientStart,
                Theme.Colors.loginGradientEnd
              ], begin: Alignment.topLeft, end: Alignment.topRight),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    offset: new Offset(3.0, 3.0),
                    color: Colors.black45)
              ]),
          child: Row(
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.location_on),
                onPressed: () => _launchmap(lat, lon),
              ),
              Spacer(),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.share),
                onPressed: () => Share.share(
                    'https://rumbero.live/eventos/show/' + eventId.toString(),
                    subject: 'Mira esto'),
              ),
            ],
          ),
        ),
        Center(
          child: FloatingActionButton(
              child: Icon(
                Icons.local_play,
                color: Theme.Colors.loginGradientEnd,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                if (contacto != null)
                  _launchContacto(contacto);
                else
                  bottomSheetMore(eventId.toString(), context);
              }),
        )
      ],
    );
  }

  Widget videoPlayer(String url) {
    return url != null ? VPlayer(urlVideo: url) : SizedBox();
  }

  Widget description(String text) {
    return InkWell(
        onTap: () => _eventBloc.changeRMore(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(colors: [
                Theme.Colors.loginGradientStart,
                Theme.Colors.loginGradientEnd
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: StreamBuilder<bool>(
            stream: _eventBloc.rMoreController.stream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data)
                return notComprimed(text);
              else
                return comprimed(text);
            },
          ),
        ));
  }

  Widget notComprimed(String text) {
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 17));
  }

  Widget comprimed(String text) {
    return Column(
      children: [
        Text(text,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style: TextStyle(color: Colors.white, fontSize: 17)),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        )
      ],
    );
  }

  Widget maps(double height, double lan, double lon) {
    //return Text('Mapita');
    return Map(lat: lan, lon: lon, alto: height);
  }
}
