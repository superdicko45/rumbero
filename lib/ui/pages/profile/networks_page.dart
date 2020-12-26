import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/profile/networks_bloc.dart';
import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/models/redes_model.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class NetworksPage extends StatefulWidget {
  NetworksPage({Key key}) : super(key: key);

  @override
  _NetworksPageState createState() => _NetworksPageState();
}

class _NetworksPageState extends State<NetworksPage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final NetworsBloc _networksBloc = new NetworsBloc();

  @override
  void initState() {
    super.initState();
    _networksBloc.getNetworks();
    _networksBloc.isLoadingController;
    _networksBloc.networksController;
    _networksBloc.opcionesController;
    _networksBloc.stateController;
  }

  @override
  void dispose() {
    super.dispose();
    _networksBloc.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Mis Enlaces'),
        backgroundColor: Theme.Colors.loginGradientEnd,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _addRow(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder<List<Redes>>(
          stream: _networksBloc.networksController.stream,
          builder: (context, snapshot) {
            if(snapshot.hasData) {

              if(snapshot.data.length > 0) 
                return body(snapshot.data);
              else 
                return _empty();
            }
            else 
              return Center(
                child: CircularProgressIndicator()
              );
          }
        ),
      )
    );
  }

  void _addRow() {
    final String _tagId = UniqueKey().toString();
    _networksBloc.addNet(_tagId);
  }

  Future<void> _saveData() async{
    
    bool _response = await _networksBloc.saveData();
    
    String text = 'Se actualizo tu info';

    if(!_response) text = 'Ocurrio un error, intenta mas tarde';

    var _snackBar = SnackBar(
      content: Text(text)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);   
  }

  Widget _empty() {
    
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(child: NoInfo(svg: 'social.svg', text: 'Tu lista esta vacia.',)),
      Expanded(
        child: Column(
          mainAxisAlignment: _orientation != Orientation.landscape 
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No dejes que eso te detenga, agrega un enlace social.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            floatinButton()
          ],
        ),
      )
    ]; 
    
    return _orientation != Orientation.landscape 
      ? Column(
        children: _items,
      ) 
      : Row(
        children: _items,
      );
  }

  Widget floatinButton(){
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(Icons.add_circle_outline),
      label: Text('Agregar'),
      onPressed: () => _addRow(), 
    );
  }

  Widget body(List<Redes> _redes){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _redes.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return itemRow(_redes[index]);
            }
          ),
        ),
        _buttonSave()
      ],
    );
  }

  Widget itemRow(Redes _network){
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          dropDown(_network),
          input(_network),
          dropRow(_network.itemId)
        ],
      ),
    );
  }

  Widget dropDown(Redes _network){

    return Expanded(
      flex: 2,
      child: StreamBuilder<List<General>>(
        stream: _networksBloc.opcionesController.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData) 
            return DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _network.socialId,
                isDense: true,
                onChanged: (int _newValue) => _networksBloc.changeType(_network.itemId, _newValue),
                items: snapshot.data.map((General _tipo) {
                  return DropdownMenuItem<int>(
                    value: _tipo.itemId,
                    child: Text(_tipo.item),
                  );
                }).toList(),
              )
            );
          else
            return SizedBox();
        }
      )
    );
  }

  Widget input(Redes _network){
    return Expanded(
      flex: 4,
      child: TextFormField(
        decoration: new InputDecoration(
          labelText: "Nombre de la cuenta*",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(
              color: Theme.Colors.loginGradientStart
            ),
          ),
        ),
        onChanged: (String _newValue) => _networksBloc.changeInput(_network.itemId, _newValue),
        initialValue: _network.url,
        keyboardType: TextInputType.text,
        maxLength: 20,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
  
  Widget dropRow(dynamic _id){
    return Expanded(
      flex: 1,
      child: IconButton(
        icon: Icon(Icons.delete_forever, color: Colors.orangeAccent,), 
        onPressed: () => _networksBloc.delNet(_id)
      ),
    );
  }

  Widget _buttonSave(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: Theme.Colors.myBoxDecButton,
        child: MaterialButton(
          onPressed: (){},
          child: _buttonState()
        )
      ),
    );
  }

  Widget _buttonState(){

    return StreamBuilder<stateType>(
      stream: _networksBloc.stateController.stream,
      initialData: stateType.WAITING,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        if (snapshot.data == stateType.LOADING) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
        } 

        else return _buttonAction();
      },
    );
  }

  Widget _buttonAction(){
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
        child: Text(
          "Guardar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontFamily: "WorkSansBold"
          ),
        ),
      ),
      onPressed: () => _saveData()
    );
  }

}