import 'package:flutter/material.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/models/search_model.dart';

import 'package:rumbero/logic/entity/models/zone_model.dart';

class ZoneSlider extends StatelessWidget {

  final List<Zone> zonas;

  const ZoneSlider({Key key, this.zonas}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Container(
      height: _orientation == Orientation.landscape ? 
        _screenSize.height * .15 : _screenSize.height * .07,
      child: LayoutBuilder(builder: (context, contraint){
        return ListView.builder(
          padding: EdgeInsets.all(5.0),
          scrollDirection: Axis.horizontal,
          itemCount: zonas.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _cardZona(zonas[index], ctxt);
          }  
        );
      }) 
    );
  }

  Widget _cardZona(Zone zona, BuildContext context){

    List<EventModelResponse> events = new List<EventModelResponse>(); 

    Search filter = new Search(
      ciudad: zona.ciudadId, 
      colonia: zona.colonia,
      filtro: true
    );
    
    List<dynamic> params = [events, filter];
    

    return InkWell(
      onTap: (){
        Navigator.pushNamed(
          context, 
          '/results_events',
          arguments: params   
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)
          ),
          border: Border.all(
            color: Colors.black38
          ) 
        ),
        child: Row(
          children: <Widget>[
            Text(zona.colonia +' / '+ zona.ciudad ),
            SizedBox(width: 20.0),
            Text('(' + zona.total.toString() + ')',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }

}