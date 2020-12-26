import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/blocs/profile/security/settings_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/settings_model_response.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  SettingsBloc _settingsBloc = new SettingsBloc();

  @override
  void initState() {
    super.initState();
    _settingsBloc.getSettings();
    _settingsBloc.showEStream;
    _settingsBloc.stateStream;
  }

  @override
  void dispose() {
    super.dispose();
    _settingsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Ajustes de privacidad'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: StreamBuilder<SettingsModelResponse>(
        stream: _settingsBloc.settingsStream,
        builder: (context, snapshot) {
          if(snapshot.hasData) 
            return _body();
          else
            return Center(
              child: CircularProgressIndicator(),
            );  
        }
      )
    );
  }

  Future<void> _saveData() async{
    
    Map<String, dynamic> _response = await _settingsBloc.saveData();
    _showSnackBar(_response["msg"], _response["error"]);    
  }

  Future<void> _deleteHistory() async{
    
    await _settingsBloc.deleteHistory();
    Navigator.of(context).pop(); 
    _showSnackBar('Se borro con éxito!', false);   
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text("¿Deseas borrar el historial de búsqueda?"),
          content: Text("Se borrara el historial búsqueda de este dispositivo de manera permanente."),
          actions: <Widget>[
            FlatButton(
              child: Text("Continuar",),
              onPressed: () => _deleteHistory(),
            ),
            FlatButton(
              child: Text("Cerrar",),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  }

  Future<void> _showSnackBar(String _text, bool _error) async{
    
    var _snackBar = SnackBar(
      content: Text(_text)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Widget _body(){
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _sEventos(), 
                Divider(),
                _historial()
              ],
            ),
          ),
          _buttonSave(),
        ],
      ),
    );
  }

  Widget _historial(){
    return ListTile(
      onTap: () => _showAlertDialog(),
      leading: FaIcon(FontAwesomeIcons.history, color: Theme.Colors.loginGradientStart,),
      title: Text('Borrar historial de búsqueda'),
      subtitle: Text('Borra el historial de reproducciones de esta cuenta en el dispositivo.'),
    );
  }

  Widget _sEventos(){
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.eye, color: Theme.Colors.loginGradientStart,),
      title: Text('Eventos visibles'),
      subtitle: Text('Si esta activado, permite hacer público tus eventos guardados.'),
      trailing: StreamBuilder<bool>(
        initialData: true,
        stream: _settingsBloc.showEStream,
        builder: (context, snapshot) {
          return Switch(
            value: snapshot.data,
            onChanged: (value) => _settingsBloc.changeShowEvent(value),
            activeTrackColor: Theme.Colors.loginGradientEnd.withOpacity(0.5),
            activeColor: Theme.Colors.loginGradientEnd,
          );
        }
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
      stream: _settingsBloc.stateStream ,
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
          "Actualizar",
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