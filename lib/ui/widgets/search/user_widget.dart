import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

class UserResult extends StatelessWidget {
  final UserModelResponse user;

  const UserResult({@required this.user});

  @override
  Widget build(BuildContext context) {
    final String _tagId = UniqueKey().toString();

    final List<String> _params = [
      user.usuarioId.toString(),
      _tagId,
      user.nombre,
      user.fotoPerfil
    ];

    return Container(
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          elevation: 7.0,
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, '/profile', arguments: _params),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              leading: leading(user.fotoPerfil, user.fotoPerfil),
              title: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            user.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.Colors.loginGradientStart,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    '@' + user.username,
                    style: TextStyle(color: Theme.Colors.loginGradientEnd),
                  ),
                  Text(', ' + user.tipoUsuario),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Theme.Colors.loginGradientEnd, size: 30.0))),
    );
  }

  Widget leading(String url, String tag) {
    final String _tagId = UniqueKey().toString();

    return Container(
        padding: EdgeInsets.only(right: 10.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(
                    width: 1.0, color: Theme.Colors.loginGradientStart))),
        child: Hero(
            tag: _tagId,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(url),
            )));
  }
}
