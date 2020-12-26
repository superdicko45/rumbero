import 'package:flutter/material.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/ui/pages/image_page.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/models/redes_model.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';

import 'package:rumbero/ui/widgets/redes_wrap_widget.dart';

class InfoPage extends StatelessWidget {

  final Academia academia;

  const InfoPage({Key key, @required this.academia}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        redes(academia.redes),
        infoMain(),
        description(),
        horario(context),
        costos(context),
        contact()
      ],
    );
  }

  Widget redes(List<Redes> redes){
    return RedesWrap(redes: redes);
  }


  Widget infoMain(){
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(academia.nombre, 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 27
            )
          ),
          Text(
            academia.eslogan, 
            style: TextStyle(
              color: Colors.black45
            )
          )
        ],
      ),
    );
  }

  Widget description(){

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
      child: Text(
        academia.descripcion,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17
        )
      ),
    );
  }

  Widget horario(BuildContext ctx){
    
    final List<Galeria> galeria = [Galeria(galeriaId: academia.horario, archivoFoto: academia.horario)];
    
    return academia.horario != null
      ? Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text('Horario', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 27
              )),
              GestureDetector(
                onTap: () => Navigator.push(
                  ctx, MaterialPageRoute(builder: (context) => ImagePage(galeria: galeria, index: 0))
                ),
                child: Image.network(academia.horario)
              )

            ],
          ),
        )
      : SizedBox();
  }

  Widget costos(BuildContext ctx){

    final List<Galeria> galeria = [Galeria(galeriaId: academia.costos, archivoFoto: academia.costos)];

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text('Costos', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 27
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                rangeText('Min', academia.rangoMin.toString()),
                rangeText('Max', academia.rangoMax.toString())
              ],
            ),
          ),
          academia.costos != null 
            ? GestureDetector(
                onTap: () => Navigator.push(
                  ctx, MaterialPageRoute(builder: (context) => ImagePage(galeria: galeria, index: 0))
                ),
                child: Image.network(academia.costos)
              )
            : SizedBox()
        ],
      ),
    );
  }

  Widget rangeText(String m, String range){
    return Column(
      children: [
        Text(
          m,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54
          ),
        )
      ],
    );
  }

  Widget contact(){
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          academia.telefono != null
            ? Card(
                child: ListTile(
                  leading: Icon(Icons.phone, color: Theme.Colors.loginGradientStart),
                  title: Text(academia.telefono),
                  subtitle: Text('Telefono'),
                ),
              )
            : SizedBox(),
          academia.pagina != null
            ?  Card(
                child: ListTile(
                  leading: Icon(Icons.public, color: Theme.Colors.loginGradientStart),
                  title: Text(academia.pagina),
                  subtitle: Text('Sitio Web'),
                ),
              )
            : SizedBox(),
        ],
      ),
    );
  }
}