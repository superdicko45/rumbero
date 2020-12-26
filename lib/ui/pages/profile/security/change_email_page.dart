import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/blocs/profile/security/change_email_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key key}) : super(key: key);

  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  ChangeEmailBloc _changeEmailBloc = new ChangeEmailBloc();

  @override
  void initState() {
    super.initState();
    _changeEmailBloc.getEmail();
    _changeEmailBloc.emailStream;
  }

  @override
  void dispose() {
    super.dispose();
    _changeEmailBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Cambio de correo'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: StreamBuilder<String>(
        stream: _changeEmailBloc.emailStream,
        builder: (context, snapshot) {
          if(snapshot.hasData || snapshot.hasError)
            return ListView(
              children: [
                _iEmail(snapshot.data, snapshot.error),
                _buttonSave(snapshot.hasError),
                _signRedirect()
              ],
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );   
        }
      )
    );
  }

  Future<void> _saveData() async{
    
    Map<String, dynamic> _response = await _changeEmailBloc.saveData();
    _showSnackBar(_response["msg"], _response["error"]);    
  }

  _showSnackBar(String _text, bool _error) async{
    
    var _snackBar = SnackBar(
      content: Text(_text)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Widget _iEmail(String text, dynamic error){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
      child: TextFormField(
        initialValue: text,
        onChanged: _changeEmailBloc.changeEmail,
        decoration: new InputDecoration(
          errorText: error,
          labelText: "Ingresa el nuevo correo *",
          fillColor: Colors.white,
          icon: FaIcon(FontAwesomeIcons.at, color: Theme.Colors.loginGradientStart,),
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
      )
    );
  }

  Widget _buttonSave(bool activo){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: Theme.Colors.myBoxDecButton,
        child: MaterialButton(
          onPressed: (){},
          child: _buttonState(activo)
        )
      ),
    );
  }

  Widget _buttonState(bool activo){

    return StreamBuilder<stateType>(
      stream: _changeEmailBloc.stateStream ,
      initialData: stateType.WAITING,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        if (snapshot.data == stateType.LOADING) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          );
        } 

        else return _buttonAction(activo);
      },
    );
  }

  Widget _buttonAction(bool activo){
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
        child: Text(
          "Actualizar",
          style: TextStyle(
            color: activo 
              ? Colors.grey
              : Colors.white,
            fontSize: 25.0,
            fontFamily: "WorkSansBold"
          ),
        ),
      ),
      onPressed: activo 
        ? null
        : () => _saveData()
    );  
  }

  Widget _signRedirect() {
    return StreamBuilder<bool>(
      stream: _changeEmailBloc.signStream,
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
                Text('Para completar esta operación se necesita una autenticación reciente, intenta iniciar sesión nuevamente.', 
                  textAlign: TextAlign.center,  
                  style: TextStyle(
                    color: Colors.black54,
                    wordSpacing: 5.0
                  )
                ),
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
        else return SizedBox();  
      }
    );    
  }
}