import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/logic/blocs/login/reset_email_bloc.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';


class ResetEmail extends StatefulWidget {
  ResetEmail({Key key}) : super(key: key);

  @override
  _ResetEmailState createState() => _ResetEmailState();
}

class _ResetEmailState extends State<ResetEmail> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final ResetEmailBloc _resetEmailBloc = new ResetEmailBloc();

  @override
  void initState() {
    super.initState();
    _resetEmailBloc.emailStream;
  }
  
  @override
  void dispose() {
    super.dispose();
    _resetEmailBloc.dispose();
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

  Future<void> _send() async {

    String _email = _resetEmailBloc.email;
    await Provider.of<LoginRepository>(context, listen: false).resetPass(_email);

    _showSnackBar();

  }

  void _showSnackBar() async{
    
    LoginResponse _response = Provider.of<LoginRepository>(context, listen: false).getResponse();

    var _snackBar = SnackBar(
      content: Text(_response.errorMessage)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Widget _horizontal(Size _screenSize){
    return ListView(
      children: <Widget>[
        _backIcon(),
        _logo(_screenSize.height * .1),
        _form(_screenSize.width),
        _singIn(),
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
              _logo(_screenSize.height * .2),
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
          onPressed: () => Navigator.pop(context)
        ),
      ],
    );
  }

  Widget _logo(double alto){
    return Column(
      children: [
        Container(
          height: alto,
          child: Center(
            child: Text(
              'Recupera tu Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 35,
                fontFamily: "WorkSansMedium"
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SvgPicture.asset(
            'assets/svg/reset_email.svg',
            height: 200.0,
          ),
        )
      ],
    );
  }

  Widget _form(double width){
    return Stack(
      alignment: Alignment(0.0, 1.25),
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
                stream: _resetEmailBloc.emailStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _resetEmailBloc.changeEmail,
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
              padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 30.0, bottom: 45.0),
              child: Text(
                'Envíaremos un códido de verificación a tu dirección de correo registrado.',
                style: TextStyle(
                  color: Colors.black54
                ),
              ),
            )
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
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Text(
          "RECUPERAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontFamily: "WorkSansBold"
          ),
        ),
      ),
      onPressed: () => _send()
    );
  }

  Widget _singIn(){
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            child: Text(
              "Iniciar sesión!",
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