import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/ui/widgets/search/academy_widget.dart';
import 'package:rumbero/ui/widgets/search/event_widget.dart';

import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/ui/widgets/search/user_widget.dart';

class Results extends StatelessWidget {

  final SearchResponse response;
  final Search filtro;

  const Results({Key key, this.filtro, @required this.response});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        _events(response.eventos, context),
        _schools(response.academias, context),
        _users(response.usuarios, context),
      ],
    );
  }


  Widget _events(List<EventModelResponse> events, BuildContext ctx){

    List<Widget> _items = List<Widget>();
    List<dynamic> _params = [events, filtro];

    _items.add(title('Eventos', _params, ctx));

    if(events != null && events.isNotEmpty){

      if(events.length > 4) events = events.sublist(0,4);
      events.forEach((element) => _items.add(EventResult(evento: element)));
      return Column(children: _items);
    }
    else return Container();
  }


  Widget _schools(List<AcademyModelResponse> schools, BuildContext ctx){

    List<Widget> _items = List<Widget>();
    List<dynamic> _params = [schools, filtro];

    _items.add(title('Academias', _params, ctx));

    if(schools != null && schools.isNotEmpty){

      if(schools.length > 4) schools = schools.sublist(0,4);
      schools.forEach((element) => _items.add(AcademyResult(academia: element)));
      return Column(children: _items);
    }
    else return Container();
  }


  Widget _users(List<UserModelResponse> users, BuildContext ctx){

    List<Widget> _items = List<Widget>();
    List<dynamic> _params = [users, filtro];
    
    _items.add(title('Usuarios', _params, ctx));

    if(users != null && users.isNotEmpty){

      if(users.length > 4) users = users.sublist(0,4);
      users.forEach((element) => _items.add(UserResult(user: element)));
      return Column(children: _items);
    }
    else return Container();
  }

  Widget title(String type, dynamic params, BuildContext context){

    String route; 
    
    switch (type) {
      case 'Usuarios':
        route = '/results_users';
        break;
      case 'Eventos':
        route = '/results_events';
        break;  
      case 'Academias':
        route = '/results_schools';
        break;  
      default:
        route = '/results_blogs';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              color: Theme.Colors.loginGradientStart,
              fontWeight: FontWeight.bold,
              fontSize: 18.0
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(
                context, 
                route,
                arguments: params   
              );
            },
            child: Text(
              'Ver todo',
              style: TextStyle(
                color: Theme.Colors.loginGradientEnd
              ),
            ),
          )
        ],
      ),
    );
  }
}