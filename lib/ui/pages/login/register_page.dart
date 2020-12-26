import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:provider/provider.dart';
import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/logic/blocs/login/register_bloc.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final RegisterBloc _registerBloc = new RegisterBloc();

  @override
  void initState() {
    super.initState();
    _registerBloc.nameStream;
    _registerBloc.emailStream;
    _registerBloc.passStream;
    _registerBloc.repsStream;
  }
  
  @override
  void dispose() {
    super.dispose();
    _registerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldstate,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Theme.Colors.myBoxDecBackG,
        child: _orientation == Orientation.landscape 
          ? _vertital(_screenSize)
          : _horizontal(_screenSize)
      ),
    );
  }

  Widget _horizontal(Size _screenSize){
    return ListView(
      children: <Widget>[
        _backIcon(),
        _logo(_screenSize.height * .17),
        _form(_screenSize.width),
        _singIn(),
        _terms(),
      ],
    );  
  }

  Widget _vertital(Size _screenSize){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _backIcon(),  
              _logo(_screenSize.height * .4),
              _terms(),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _form(_screenSize.width * .6),
              _singIn(),
            ],
          ),
        )
      ],
    );
  }

  Widget _backIcon(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 36,
          ), 
          onPressed: () => Navigator.of(context).pushNamed('/')
        ),
      ],
    );
  }

  Widget _logo(double alto){
    return Container(
      height: alto,
      child: Center(
        child: Text(
          'Crea una cuenta',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 40,
            fontFamily: "WorkSansMedium"
          ),
        ),
      ),
    );
  }

  Widget _form(double width){
    return Stack(
      alignment: Alignment(0.0, 1.1),
      overflow: Overflow.visible,
      children: <Widget>[
        _formRegister(width * .8),
        _registerButton(),
      ],
    );
  }

  Widget _formRegister(double width){
    return Card(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _registerBloc.nameStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _registerBloc.changeName,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                      hintText: "Nombre",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                    ),
                  );
                }
              ),
            ),
            Container(
              width: width * .8,
              height: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _registerBloc.emailStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _registerBloc.changeEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.black,
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                    ),
                  );
                }
              ),
            ),
            Container(
              width: width * .8,
              height: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _registerBloc.passStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _registerBloc.changePass,
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.black,
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                    ),
                  );
                }
              ),
            ),
            Container(
              width: width * .8,
              height: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 40.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _registerBloc.repsStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _registerBloc.changeReps,
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: "WorkSansSemiBold",
                      fontSize: 16.0,
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      errorText: snapshot.error,
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.lock,
                        color: Colors.black,
                      ),
                      hintText: "Confirmacion",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton(){
    return Container(
      decoration: Theme.Colors.myBoxDecButton,
      child: MaterialButton(
        onPressed: (){},
        child: _buttonState()
      )
    );
  }

  Widget _buttonState(){
    
    stateType _currentState = Provider.of<LoginRepository>(context).wichtState();
    
    if (_currentState == stateType.SUCCESS) return Icon(Icons.check, color: Colors.white);
    
    else if (_currentState == stateType.LOADING) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } 

    else return _button();
  }

  Widget _button(){
    return StreamBuilder<bool>(
      stream: _registerBloc.formValidStream,
      builder: (context, snapshot) {
        return MaterialButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "ÚNETE",
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
            ? () => _register()
            : null
        );
      }
    );
  }

  Future<void> _register() async{
    
    await Provider.of<LoginRepository>(context, listen: false)
      .login(
        loginType.REGISTER,
        email: _registerBloc.email,
        pass: _registerBloc.pass,
        name: _registerBloc.name
      );
    
    _showSnackBar();    
  }

  _showSnackBar() async{
    
    LoginResponse _response = Provider.of<LoginRepository>(context, listen: false).getResponse();

    //Si no hay error redirige al inicio
    if(!_response.error)
      //Navigator.of(context).pushNamed('/');
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

    
    //Si hay error mostrara un error
    else{  
      var _snackBar = SnackBar(
        content: Text(_response.errorMessage)
      );

      _scaffoldstate.currentState.showSnackBar(_snackBar);
    }
  }

  Widget _terms(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Al hacer clic en 'Únete', aceptas nuestros",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "WorkSansMedium"
              ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Términos y Condiciones.",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "WorkSansMedium"
              ),
            )
          ),
        ],
      ),
    );
  }
  
  Widget _singIn(){
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '¿Ya tienes cuenta?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "WorkSansMedium"
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            child: Text(
              "Entra!",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "WorkSansMedium"
              ),
            )
          ),
        ],
      ),
    );
  }
}