import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';

class AcademyResult extends StatelessWidget {
  final AcademyModelResponse academia;

  const AcademyResult({@required this.academia});

  @override
  Widget build(BuildContext context) {
    final String _tagId = UniqueKey().toString();

    final List<String> _params = [
      academia.academiasId.toString(),
      _tagId,
      academia.nombre,
      academia.perfilImagen
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
                  Navigator.pushNamed(context, '/academy', arguments: _params),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              leading: imageCover(academia.perfilImagen),
              title: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            academia.nombre,
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
                children: <Widget>[
                  Text(academia.total.toString()),
                  Text(academia.total > 1 ? ' academias' : 'academia'),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Theme.Colors.loginGradientEnd, size: 30.0))),
    );
  }

  Widget imageCover(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)),
      child: FadeInImage(
        width: 100,
        image: NetworkImage(url),
        placeholder: AssetImage('assets/img/tempo.gif'),
        fit: BoxFit.cover,
      ),
    );
  }
}
