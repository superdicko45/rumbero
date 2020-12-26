import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/logic/blocs/academy/academy_bloc.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/academy/maps_widget.dart';
import 'package:rumbero/ui/widgets/academy/resena_widget.dart';
import 'package:rumbero/ui/widgets/flexible_appbar_widget.dart';
import 'package:rumbero/ui/widgets/academy/galery_widget.dart';
import 'package:rumbero/ui/widgets/academy/info_widget.dart';

class AcademyPage extends StatefulWidget {

  final dynamic params;

  const AcademyPage({@required this.params, Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<AcademyPage> with SingleTickerProviderStateMixin{

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

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder<Academia>(
      stream: _academyBloc.academyController.stream,
      builder: (context, snapshot) {

        if(snapshot.hasData) 
          return Scaffold(
            body: NestedScrollView(
              controller: sVController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[myAppBar(screenSize, snapshot.data)];
              },
              body: customTabView(snapshot.data),
            )
          );

        else
          return Center(
            child: CircularProgressIndicator(),
          );  
      }
    );
  }

  Widget myAppBar(Size screenSize, Academia academia){

    return SliverAppBar(
      title: customAppBar(academia.nombre),
      backgroundColor: Theme.Colors.loginGradientStart,
      pinned: true,
      expandedHeight: screenSize.height * 0.38,
      flexibleSpace: FlexibleSpaceBar(
        background: CustomFlexibleAppBar(
          urlImage: academia.perfilImagen,
          followers: '75',
          follows: '15',
        ),
      ),
      bottom: customTabBar(),  
    );
  }

  Widget customAppBar(String name){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget customTabBar(){

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

  Widget customTabView(Academia academia){
    return TabBarView(
      children: [
        InfoPage(academia: academia),
        GaleryPage(academyId: academia.academiasId, galeria: academia.galeria,),
        SucursalPage(sucursales: academia.sucursales,),
        ResenaPage(academia: academia)
      ],
      controller: tController,
    );
  }

}