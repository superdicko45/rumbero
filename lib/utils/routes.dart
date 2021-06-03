import 'package:flutter/material.dart';

import 'package:rumbero/ui/pages/academy_page.dart';
import 'package:rumbero/ui/pages/event_page.dart';
import 'package:rumbero/ui/pages/home/main_page.dart';
import 'package:rumbero/ui/pages/blog_page.dart';
import 'package:rumbero/ui/pages/intro_page.dart';
import 'package:rumbero/ui/pages/user_page.dart';
import 'package:rumbero/ui/pages/ticket_page.dart';

//search
import 'package:rumbero/ui/pages/search/results_page.dart';
import 'package:rumbero/ui/pages/search/filter_page.dart';
import 'package:rumbero/ui/pages/search/types/events_list_page.dart';
import 'package:rumbero/ui/pages/search/types/blog_list_page.dart';
import 'package:rumbero/ui/pages/search/types/schools_list_page.dart';
import 'package:rumbero/ui/pages/search/types/users_list_page.dart';

//Pages of Login
import 'package:rumbero/ui/pages/login/reset_email_page.dart';
import 'package:rumbero/ui/pages/login/register_page.dart';
import 'package:rumbero/ui/pages/login/signin_page.dart';

//Pages of user profile
import 'package:rumbero/ui/pages/profile/networks_page.dart';
import 'package:rumbero/ui/pages/profile/my_profile_page.dart';
import 'package:rumbero/ui/pages/profile/edit_profile_page.dart';
import 'package:rumbero/ui/pages/profile/my_events_page.dart';
import 'package:rumbero/ui/pages/profile/security_page.dart';

//pages of security profile
import 'package:rumbero/ui/pages/profile/security/change_email_page.dart';
import 'package:rumbero/ui/pages/profile/security/change_pass_page.dart';
import 'package:rumbero/ui/pages/profile/security/settings_page.dart';

class RouterOwn {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
      //return MaterialPageRoute(builder: (_) => IntroPage());
      case '/intro':
        return MaterialPageRoute(builder: (_) => IntroPage());
      case '/ticket':
        var arguments = settings.arguments;
        return MaterialPageRoute(builder: (_) => TicketPage(params: arguments));
      case '/event':
        var arguments = settings.arguments;
        return MaterialPageRoute(builder: (_) => EventPage(params: arguments));
      case '/blog':
        var arguments = settings.arguments;
        return MaterialPageRoute(builder: (_) => BlogPage(params: arguments));
      case '/profile':
        var arguments = settings.arguments;
        return MaterialPageRoute(builder: (_) => UserPage(params: arguments));
      case '/academy':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => AcademyPage(params: arguments));

      //Paginas de busqueda
      case '/results':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ResultsPage(
                  filtro: arguments,
                ));
      case '/filter':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => FilterPage(
                  filtro: arguments,
                ));
      case '/results_events':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => EventsListPage(params: arguments));
      case '/results_users':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => UsersListPage(params: arguments));
      case '/results_schools':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SchoolsListPage(params: arguments));
      case '/results_blogs':
        return MaterialPageRoute(builder: (_) => BlogsListPage());

      //Paginas de inicio de sesion
      case '/login':
        var arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SignIn(redirectUrl: arguments));
      case '/resetEmail':
        return MaterialPageRoute(builder: (_) => ResetEmail());
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());

      //A partir de aqui son las paginas correspondientes al usuario
      case '/myProfile':
        return MaterialPageRoute(builder: (_) => MyProfilePage());
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      case '/myEvents':
        return MaterialPageRoute(builder: (_) => MyEventspage());
      case '/myNetworks':
        return MaterialPageRoute(builder: (_) => NetworksPage());
      case '/security':
        return MaterialPageRoute(builder: (_) => SecurityPage());

      //A partir de aqui son las paginas correspondientes a la seguridad del usuario
      case '/security/email':
        return MaterialPageRoute(builder: (_) => ChangeEmailPage());
      case '/security/pass':
        return MaterialPageRoute(builder: (_) => ChangePassPage());
      case '/security/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());

      default:
        // si no hay coincidencias, pantalla de error
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
