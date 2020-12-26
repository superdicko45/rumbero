import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/models/ticket_model.dart';
import 'package:rumbero/logic/blocs/event/ticket_bloc.dart';

class TicketPage extends StatefulWidget {

  final dynamic params;

  const TicketPage({Key key, @required this.params}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {

  TicketBloc _ticketBloc = new TicketBloc();

  void initState() {
    super.initState();
    _ticketBloc.getTicket(
      widget.params[0],
      widget.params[1]
    );
  }

  @override
  void dispose(){
    _ticketBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    final double _width = _orientation == Orientation.landscape 
      ? _screenSize.width * .5 
      : _screenSize.width * .75;

    final double _mgTop = _orientation == Orientation.landscape 
      ? _screenSize.height * .05 
      : _screenSize.height * .1;  

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Theme.Colors.myBoxDecBackG,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: _mgTop),
          child: _body(_width, context),
        )
      ),
    );
  }

  Widget _backIcon(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 55.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 36,
            ), 
            onPressed: () => Navigator.of(context).pop()
          ),
        ],
      ),
    );
  }

  Widget _body(double _width, BuildContext ctx){
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _backIcon(ctx),
        StreamBuilder<Ticket>(
          stream: _ticketBloc.ticketController.stream,
          builder: (context, snapshot) {
            return snapshot.hasData
              ? Stack(
                  alignment: Alignment(0, -1.3),
                  children: [
                    _main(_width, snapshot.data.user, snapshot.data.folio.toString()),
                    imgCover(_width - 20, snapshot.data.imagen)
                  ],
                )
              : Center(child: CircularProgressIndicator(),)  ;
          }
        )
      ],
    );
  }

  Widget _main(double _width, String username, String folio){

    const TextStyle hard = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black
    );

    const TextStyle fade = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black38
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 115),
        height: 500,
        width: _width,
        child: Column(
          children: [          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invitado', style: fade),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(username, style: hard,),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Folio', style: fade),
                    Text(folio, style: hard,)
                  ],
                ),
              ],
            ),
            lineDoted(),
            _qrCode(username, folio),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  backgroundColor: Theme.Colors.loginGradientEnd,
                  label: Text('Rumbero Ticket', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imgCover(double _width, String img) {
    return ClipRRect(
      child: Image.network(
        img,
        width: _width,
        height: 160,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    );
  }

  Widget lineDoted(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
      children: List.generate(150~/10, (index) => 
        Expanded(
          child: Container(
            color: index%2==0
              ? Colors.transparent
              : Colors.grey,
            height: 2,
          ),
        )
        ),
      ),
    );
  }

  Widget _qrCode(String username, String folio){
    return QrImage(
      data: 'Nombre: $username , folio: $folio',
      version: QrVersions.auto,
      size: 250,
      gapless: false,
    );
  }
}