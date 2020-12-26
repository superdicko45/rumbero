import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/logic/blocs/user/user_bloc.dart';
import 'package:rumbero/logic/entity/models/show_user_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/flexible_appbar_widget.dart';
import 'package:rumbero/ui/widgets/users/galery_widget.dart';
import 'package:rumbero/ui/widgets/users/info_widget.dart';
import 'package:rumbero/ui/widgets/users/events_widget.dart';

class UserPage extends StatefulWidget {

  final String userId;

  const UserPage({
    @required this.userId,
    Key key
  }) 
  : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  UserBloc userBloc = new UserBloc();
  TabController tController;
  ScrollController sVController;

  @override
  void initState() {
    super.initState();
    userBloc.showUser(widget.userId);
    tController = new TabController(length: 3, vsync: this);
    sVController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    userBloc.dispose();
    tController.dispose();
    sVController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldstate,
      body: StreamBuilder<User>(
        stream: userBloc.subject.stream,
        builder: (context, AsyncSnapshot<User> snapshot) {

          if (snapshot.hasData) {
            return NestedScrollView(
              controller: sVController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  myAppBar(snapshot.data)
                ];
              },
              body: customTabView(snapshot.data),
            );
          }
          else return CircularProgressIndicator();
        }
      ),
    );
  }

  Widget myAppBar(User user){

    Size screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      title: customAppBar(
        user.username != null
          ? user.username
          : user.nombre
      ),
      backgroundColor: Theme.Colors.loginGradientStart,
      pinned: true,
      expandedHeight: screenSize.height * 0.35,
      flexibleSpace: FlexibleSpaceBar(
          background: CustomFlexibleAppBar(
            urlImage: user.fotoPerfil,
            followers: user.seguidores.toString(),
            follows: user.seguidos.toString(),
          ),
        ),
      bottom: customTabBar(),  
    );
  }

  Widget customAppBar(String nombre){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(nombre)
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
        Tab(icon: new Icon(Icons.calendar_today)),
      ],
    );
  }

  Widget customTabView(User user){
    return TabBarView(
      children: [
        InfoPage(user: user),
        GaleryPage(
          userId: user.usuarioId, 
          galeria: user.galeria, 
          uploadImg: user.uploadImg, 
          scaffoldstate: _scaffoldstate,
        ),
        user.eventos.length > 0
          ? EventPage(eventos: user.eventos)
          : NoInfo(svg: 'events.svg', text: 'No pudimos encontrar eventos de este usuario.',),
      ],
      controller: tController,
    );
  }

}