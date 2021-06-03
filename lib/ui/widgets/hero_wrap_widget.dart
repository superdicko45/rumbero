import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

class HeroWrap extends StatelessWidget {
  final List<UserModelResponse> usuarios;
  const HeroWrap({@required this.usuarios, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: usuarios.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return invitado(ctxt, usuarios[index]);
          }),
    );
  }

  Widget invitado(BuildContext context, UserModelResponse invitado) {
    final String _tagId = UniqueKey().toString();

    final List<String> _params = [
      invitado.usuarioId.toString(),
      _tagId,
      invitado.nombre,
      invitado.fotoPerfil
    ];

    return Container(
      margin: EdgeInsets.only(left: 20, right: 12, top: 20, bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/profile', arguments: _params);
        },
        child: Column(
          children: <Widget>[
            Hero(
              tag: _tagId,
              child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(invitado.fotoPerfil)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                invitado.nombre,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                invitado.tipoUsuario != null
                    ? invitado.tipoUsuario
                    : 'Indefinido',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
