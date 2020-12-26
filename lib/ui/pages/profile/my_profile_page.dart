import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/profile/profile_bloc.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  ProfileBloc _profileBloc = new ProfileBloc();
  GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _profileBloc.usIdStream;
    _profileBloc.nameStream;
    _profileBloc.mailStream;
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final _screenSize = MediaQuery.of(context).size;
  final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldstate,
      body: _orientation == Orientation.landscape
        ? _vertical(_screenSize)
        : _horizontal(_screenSize),
    ); 
  }

  Future<void> loadAssets() async {

    try {
      List<Asset> _resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );

      var _snackBar = SnackBar(
        content: Text('Subiendo galería...')
      );

      _scaffoldstate.currentState.showSnackBar(_snackBar);

      await _profileBloc.uploadImgPtofile(_resultList);

    } on Exception catch (e) {
      e.toString();
    }

    if (!mounted) return;
  }

  Widget _horizontal(Size _screenSize){
    return Column(
      children: <Widget>[
        _mainProfile(_screenSize.height * .3,_screenSize.width),
        _listItems()
      ],
    );
  }

  Widget _vertical(Size _screenSize){
    return Row(
      children: <Widget>[
        _mainProfile(_screenSize.height, _screenSize.width * .35 ),
        _listItems()
      ],
    );
  }

  Widget _listItems(){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person_pin, color: Theme.Colors.loginGradientStart,),
              title: Text('Mi perfil'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => 
              Navigator.pushNamed(
                context, 
                '/profile',
                arguments: _profileBloc.usIdStream
              )
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.calendarDay, color: Theme.Colors.loginGradientStart,),
              title: Text('Mis eventos'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/myEvents'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.userEdit, color: Theme.Colors.loginGradientStart,),
              title: Text('Editar perfil'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/editProfile'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.globe, color: Theme.Colors.loginGradientStart,),
              title: Text('Mis enlaces'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/myNetworks'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.lock, color: Theme.Colors.loginGradientStart,),
              title: Text('Seguridad'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/security'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.headphones, color: Theme.Colors.loginGradientStart,),
              title: Text('Centro de ayuda'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.infoCircle, color: Theme.Colors.loginGradientStart,),
              title: Text('Acerce de Rumbero'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainProfile(double alto, double ancho){

    return Container(
      width: ancho,
      height: alto,
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _imageProfile(),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: StreamBuilder<String>(
                stream: _profileBloc.nameStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    return Text(
                      snapshot.data, 
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    );
                  else return Text('');  
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
              child: StreamBuilder<String>(
                stream: _profileBloc.mailStream,
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    return Text(
                      snapshot.data, 
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500
                      ),
                    );
                  else return Text('');  
                }
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _imageProfile(){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        StreamBuilder<String>(
          stream: _profileBloc.perfilStream,
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null)
              return CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data),
                radius: 60,
              );
            else  
              return CircleAvatar(
                backgroundImage: AssetImage('assets/img/no-image.jpg'),
                radius: 60,
              );
          }
        ),
        ClipOval(
          child: Material(
            color: Theme.Colors.loginGradientEnd,
            child: InkWell(
              splashColor: Colors.red, // inkwell color
              child: SizedBox(width: 40, height: 40, child: Icon(Icons.add_photo_alternate, color: Colors.white,)),
              onTap: () => loadAssets(),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration _boxDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.Colors.loginGradientStart,
          Theme.Colors.loginGradientEnd
        ],
        begin: Alignment.topLeft,
        end: Alignment.topRight
      )
    );
  }

}