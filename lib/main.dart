import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:rumbero/logic/provider/push_notifications_provider.dart';

import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'utils/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    PushNotificationProvider pushProvider = PushNotificationProvider();
    pushProvider.initializeFlutterFire();
    pushProvider.initMessage(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginRepository>(
      create: (context) => new LoginRepository(),
      child: MaterialApp(
        title: 'Rumbero',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          accentColor: Theme.Colors.loginGradientEnd,
        ),
        onGenerateRoute: RouterOwn.generateRoute,
        initialRoute: '/',
        supportedLocales: [Locale('es'), Locale('en')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
