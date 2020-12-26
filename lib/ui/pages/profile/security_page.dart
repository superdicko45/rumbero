import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/logic/repository/login_repository.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad e Inicio de sesión'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
              leading: FaIcon(FontAwesomeIcons.at, color: Theme.Colors.loginGradientStart,),
              title: Text('Cambiar email'),
              subtitle: Text('Si tiene mucho tiempo que iniciaste sesión, se te pedira nueva autenticación'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/security/email'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.shieldAlt, color: Theme.Colors.loginGradientStart,),
              title: Text('Ajustes'),
              subtitle: Text('Revisar los ajustes de privacidad'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/security/settings'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.key, color: Theme.Colors.loginGradientStart,),
              title: Text('Cambiar contraseña'),
              subtitle: Text('Si tiene mucho tiempo que iniciaste sesión, se te pedira nueva autenticación'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed('/security/pass'),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.signOutAlt, color: Theme.Colors.loginGradientStart,),
              title: Text('Cerrar sesión'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Provider.of<LoginRepository>(context, listen: false).logout();
                Navigator.of(context).pushNamed('/');
              }
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.home, color: Theme.Colors.loginGradientStart,),
              title: Text('Probar intro (temporal)'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed('/intro');
              }
            ),
          ],
        ),
      ),
    );
  }
}