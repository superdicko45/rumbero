import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/ui/pages/profile/my_profile_page.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {

    bool isLogin = Provider.of<LoginRepository>(context).isLogin();

    return isLogin 
      ? MyProfilePage()
      : _empty(context);
  }

  Widget _empty(BuildContext context) {
    
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(
        child: NoInfo(svg: 'signin.svg', text: '',)
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Para iniciar sesión, da click en el siguiente enlace.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            floatinButton(context)
          ],
        ),
      )
    ]; 
    
    return _orientation != Orientation.landscape 
      ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _items,
      ) 
      : Row(
        children: _items,
      );
  }

  Widget floatinButton(BuildContext context){
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(Icons.input, color: Colors.white,),
      label: Text('Iniciar sesión',  style: TextStyle(color: Colors.white),),
      onPressed: () => Navigator.pushNamed(context, '/login'), 
    );
  }
}