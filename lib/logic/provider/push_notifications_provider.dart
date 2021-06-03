import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:rumbero/logic/provider/user_provider.dart';

class PushNotificationProvider {
  PushNotificationProvider._();

  factory PushNotificationProvider() => _instance;

  static final PushNotificationProvider _instance =
      PushNotificationProvider._();

  final UserProvider _userProvider = new UserProvider();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initializedMessage = false;
  bool _initializedFlutterFire = false;

  // Define an async function to initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    if (!_initializedFlutterFire) {
      try {
        await Firebase.initializeApp();
        _initializedFlutterFire = true;
      } catch (e) {
        _initializedFlutterFire = false;
      }
    }
  }

  Future<void> initMessage(GlobalKey<NavigatorState> navigatorKey) async {
    if (!_initializedMessage) {
      // Para iOS
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

      _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          _serialiseAndNavigate(message, navigatorKey);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          _serialiseAndNavigate(message, navigatorKey);
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print(token);
      _userProvider.saveToken(token);

      _initializedMessage = true;
    }
  }

  void _serialiseAndNavigate(
      Map<String, dynamic> message, GlobalKey<NavigatorState> navigatorKey) {
    var notificationData = message['data'];
    var view = notificationData['view'];
    final String _tagId = UniqueKey().toString();

    List<String> _params = new List<String>();

    if (view != null) {
      switch (view) {
        case '/blog':
          _params = [
            _tagId,
            notificationData['blogId'],
            notificationData['image'],
            notificationData['titulo']
          ];
          break;
        case '/academy':
          _params = [
            notificationData['academyId'],
            _tagId,
            notificationData['academy'],
            notificationData['image'],
          ];
          break;
        case '/event':
          _params = [
            notificationData['eventId'],
            _tagId,
            notificationData['image'],
            notificationData['tipo'],
            notificationData['cover']
          ];
          break;
        default:
      }
      navigatorKey.currentState.pushNamed(view, arguments: _params);
    } else
      navigatorKey.currentState.pushNamed('/');
  }
}
