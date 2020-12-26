import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/models/redes_model.dart';
import 'package:rumbero/logic/entity/models/show_user_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';

import '../chip_slider_widget.dart';

class InfoPage extends StatelessWidget {
  
  final User user;

  const InfoPage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        redes(user.redes),
        infoMain(user.nombre, user.tipoUsuario),
        ChipSlider(categories: user.categorias),
        user.descripcion != null 
          ? description(user.descripcion)
          : description('Sin descripción')
      ],
    );
  }

  Widget redes(List<Redes> redes){
    return RedesWrap(redes: redes);
  }

  Widget infoMain(String nombre, String tipo){
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(nombre, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 27
          )),
          Text(
            tipo != null 
              ? tipo
              : 'No definido', 
            style: TextStyle(
              color: Colors.black45
            )
          )
        ],
      ),
    );
  }

  Widget description(String descripcion){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          colors: [
            Theme.Colors.loginGradientStart,
            Theme.Colors.loginGradientEnd
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
      child: Text(descripcion, style: TextStyle(
        color: Colors.white,
        fontSize: 17
      )),
    );
  }

}