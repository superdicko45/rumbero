import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'utils/routes.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginRepository>(
      create: (context) => new LoginRepository(),
      child: MaterialApp(
        title: 'Rumbero',
        theme: new ThemeData(
          accentColor: Theme.Colors.loginGradientEnd,
        ),
        onGenerateRoute: Router.generateRoute,
        initialRoute: '/',
        supportedLocales: [
          Locale('es'),
          Locale('en')
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
