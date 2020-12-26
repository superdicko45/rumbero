import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/blocs/profile/security/change_pass_bloc.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({Key key}) : super(key: key);

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  ChangePassBloc _changePassBloc = new ChangePassBloc();

  @override
  void initState() {
    super.initState();
    _changePassBloc.apassStream;
    _changePassBloc.npassStream;
    _changePassBloc.rpassStream;
  }

  @override
  void dispose() {
    super.dispose();
    _changePassBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Cambio de contraseña'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: ListView(
        children: [
          _signRedirect(),
          _iActual(),
          _iNewPass(),
          _iRePass(), 
          _buttonSave(),
        ],
      )
    );
  }

  Future<void> _saveData() async{
    
    Map<String, dynamic> _response = await _changePassBloc.saveData();
    _showSnackBar(_response["msg"], _response["error"]);    
  }

  _showSnackBar(String _text, bool _error) async{
    
    var _snackBar = SnackBar(
      content: Text(_text)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Widget _iActual(){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: StreamBuilder<String>(
        stream: _changePassBloc.apassStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: _changePassBloc.changeAPass,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              labelText: "Contraseña actual*",
              fillColor: Colors.white,
              icon: FaIcon(FontAwesomeIcons.key, color: Theme.Colors.loginGradientStart,),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: new BorderSide(
                  color: Theme.Colors.loginGradientStart
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            maxLength: 100,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          );
        }
      )
    );
  }

  Widget _iNewPass(){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: StreamBuilder<String>(
        stream: _changePassBloc.npassStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: _changePassBloc.changeNPass,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              labelText: "Contraseña nueva*",
              fillColor: Colors.white,
              icon: FaIcon(FontAwesomeIcons.key, color: Theme.Colors.loginGradientStart,),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: new BorderSide(
                  color: Theme.Colors.loginGradientStart
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            maxLength: 100,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          );
        }
      )
    );
  }

  Widget _iRePass(){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: StreamBuilder<String>(
        stream: _changePassBloc.rpassStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: _changePassBloc.changeRPass,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              labelText: "Repetir contraseña nueva*",
              fillColor: Colors.white,
              icon: FaIcon(FontAwesomeIcons.key, color: Theme.Colors.loginGradientStart,),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: new BorderSide(
                  color: Theme.Colors.loginGradientStart
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            maxLength: 100,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          );
        }
      )
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
      stream: _changePassBloc.stateStream ,
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
    return StreamBuilder<bool>(
      stream: _changePassBloc.formValidStream,
      builder: (context, snapshot) {
        return MaterialButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Actualizar",
              style: TextStyle(
                color: snapshot.hasData 
                  ? Colors.white
                  : Colors.grey,
                fontSize: 25.0,
                fontFamily: "WorkSansBold"
              ),
            ),
          ),
          onPressed: snapshot.hasData 
            ? () => _saveData()
            : null
        );
      }
    );  
  }

  Widget _signRedirect() {
    return StreamBuilder<bool>(
      stream: _changePassBloc.signStream,
      initialData: false,
      builder: (context, snapshot) {
        if(snapshot.data)
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Algo ha salido mal.', style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                )),
                SizedBox(height: 30.0,),
                Text('Parece que no has iniciado sesión en mucho tiempo, intenta volver a autenticarte', style: TextStyle(
                  color: Colors.black54
                )),
                SizedBox(height: 20.0,),
                FloatingActionButton.extended(
                  backgroundColor: Theme.Colors.loginGradientStart,
                  icon: FaIcon(FontAwesomeIcons.signInAlt),
                  label: Text('Iniciar sesión'),
                  onPressed: () => Navigator.pushNamed(
                    context, 
                    '/login',
                    arguments: '/security/email'
                  ), 
                )
              ],
            ),
          );
        else return SizedBox(height: 25.0,);  
      }
    );    
  }
}