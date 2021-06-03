import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/academy/academy_bloc.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';

import 'package:rumbero/ui/widgets/academy/maps_widget.dart';
import 'package:rumbero/ui/widgets/academy/resena_widget.dart';
import 'package:rumbero/ui/widgets/flexible_appbar_widget.dart';
import 'package:rumbero/ui/widgets/academy/galery_widget.dart';
import 'package:rumbero/ui/widgets/academy/info_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class AcademyPage extends StatefulWidget {
  final dynamic params;

  const AcademyPage({@required this.params, Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<AcademyPage>
    with SingleTickerProviderStateMixin {
  AcademyBloc _academyBloc = new AcademyBloc();
  TabController tController;
  ScrollController sVController;

  @override
  void initState() {
    super.initState();
    _academyBloc.showAcademy(widget.params[0]);
    tController = new TabController(length: 4, vsync: this);
    sVController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    super.dispose();
    _academyBloc.dispose();
    tController.dispose();
    sVController.dispose();
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: StreamBuilder<Academia>(
            stream: _academyBloc.academyController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.data.error &&
                  snapshot.data.contacto != null)
                return _reservar(snapshot.data.contacto);
              else
                return SizedBox();
            }),
        body: NestedScrollView(
            controller: sVController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[myAppBar(screenSize)];
            },
            body: StreamBuilder<Academia>(
                stream: _academyBloc.academyController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return customTabView(snapshot.data);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }

  Widget _reservar(String contacto) {
    return FloatingActionButton.extended(
        icon: Icon(
          Icons.add_to_home_screen,
          color: Colors.white,
        ),
        label: Text(
          'Reservar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.Colors.loginGradientEnd,
        onPressed: () => _launchContacto(contacto));
  }

  Widget _empty() {
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(
          flex: 4,
          child: NoInfo(
            svg: 'events.svg',
            text: 'Ocurrió un problema al cargar la academia.',
          )),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: _orientation != Orientation.landscape
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
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
                onPressed: () => _academyBloc.showAcademy(widget.params[0]))
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

  Widget myAppBar(Size screenSize) {
    return SliverAppBar(
      title: customAppBar(widget.params[2], widget.params[0]),
      backgroundColor: Theme.Colors.loginGradientStart,
      pinned: true,
      expandedHeight: screenSize.height * 0.38,
      flexibleSpace: FlexibleSpaceBar(
        background: CustomFlexibleAppBar(
          urlImage: widget.params[3],
          followers: '75',
          follows: '15',
        ),
      ),
      bottom: customTabBar(),
    );
  }

  Widget customAppBar(String name, String academyId) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.share(
                  'https://rumbero.live/academias/show/' + academyId,
                  subject: 'Mira esto'),
            ),
          )
        ],
      ),
    );
  }

  Widget customTabBar() {
    return TabBar(
      controller: tController,
      tabs: <Widget>[
        Tab(icon: new Icon(Icons.info)),
        Tab(icon: new Icon(FontAwesomeIcons.images)),
        Tab(icon: new Icon(FontAwesomeIcons.mapMarkedAlt)),
        Tab(icon: new Icon(FontAwesomeIcons.comments)),
      ],
    );
  }

  Widget customTabView(Academia academia) {
    return academia.error
        ? _empty()
        : TabBarView(
            children: [
              InfoPage(academia: academia),
              GaleryPage(
                academyId: academia.academiasId,
                galeria: academia.galeria,
              ),
              SucursalPage(
                sucursales: academia.sucursales,
              ),
              ResenaPage(academia: academia)
            ],
            controller: tController,
          );
  }
}
