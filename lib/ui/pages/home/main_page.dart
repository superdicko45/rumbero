import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/logic/blocs/home/main_bloc.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/ui/pages/home/events_page.dart';
import 'package:rumbero/ui/pages/home/home_page.dart';
import 'package:rumbero/ui/pages/home/brands_page.dart';
import 'package:rumbero/ui/pages/home/schools_page.dart';
import 'package:rumbero/ui/pages/home/profile_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  int selectedIndex = 0;
  PageController controller = PageController();
  MainBloc _mainBloc = new MainBloc();

  @override
  void initState() {
    super.initState();
    launchIntro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomNavigator()
    );
  }

  void launchIntro() async {
    final prefs = await SharedPreferences.getInstance();
    bool launch = prefs.getBool('launch') ?? true;
    prefs.setBool('launch', false);
    if (launch) {
      Navigator.of(context).pushNamed("/intro");
    }
    else{
      _mainBloc.indexController;
      initialDate();
    } 
  }

  Future<void> initialDate() async{
    await initializeDateFormatting('es_ES');
  }

  void _changePage(int index, bool changePage) {
    _mainBloc.changeIndex(index);
    if(changePage) controller.jumpToPage(index);
  }

  Widget _bottomNavigator(){

    final List<Map<String, dynamic>> _items = [
      {
        'icon' : FontAwesomeIcons.home,
        'text' : 'Inicio'
      },
      {
        'icon' : FontAwesomeIcons.solidCalendarCheck,
        'text' : 'Eventos'
      },
      {
        'icon' : FontAwesomeIcons.shoppingBag,
        'text' : 'Artículos'
      },
      {
        'icon' : FontAwesomeIcons.graduationCap,
        'text' : 'Academias'
      },
      {
        'icon' : FontAwesomeIcons.userAlt,
        'text' : 'Perfil'
      }
    ];

    List<GButton> _iconButns = new List<GButton>();

    _items.forEach((element) {
      _iconButns.add(
        new GButton(
          gap: 10.0,
          iconActiveColor: Colors.white,
          iconColor: Colors.white38,
          textColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(.2),
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          icon: element['icon'],
          text: '', //element['text'],
        )
      );
    });

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
        decoration: Theme.Colors.myBoxDecNav,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: StreamBuilder<int>(
            stream: _mainBloc.indexController.stream,
            initialData: 0,
            builder: (context, snapshot) {
              return GNav(
                tabs: _iconButns,
                selectedIndex: snapshot.data,
                onTabChange: (index) => _changePage(index, true)
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _appBar(){
    return AppBar(
      backgroundColor: Theme.Colors.loginGradientStart,
      title: Text('Ya sabes donde ir?'),
      leading: FlutterLogo(),
      actions: <Widget>[
        
        IconButton(
          icon: Icon(FontAwesomeIcons.userAlt),
          onPressed: () => Navigator.of(context).pushNamed('/results')
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.of(context).pushNamed('/results')
        ),
      ],
    );
  }

  Widget _body(){
    return PageView(
      controller: controller,
      onPageChanged: (index) => _changePage(index, false),
      children: [
        HomePage(),
        EventsPage(),
        BrandsPage(),
        SchoolsPage(),
        ProfilePage()
      ],
    );
  }

}

