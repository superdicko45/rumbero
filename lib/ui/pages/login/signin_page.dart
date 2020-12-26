import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/login/login_bloc.dart';
import 'package:rumbero/logic/repository/login_repository.dart';
import 'package:rumbero/logic/entity/responses/login_response.dart';

class SignIn extends StatefulWidget {

  final String redirectUrl;

  SignIn({Key key, this.redirectUrl}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final LoginBloc _loginBloc = new LoginBloc();

  void initState() {
    super.initState();
    _loginBloc.emailStream;
    _loginBloc.passStream;
  }

  @override
  void dispose(){
    _loginBloc.dispose();
    super.dispose();
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
        _logo(_screenSize.height * .32),
        _form(_screenSize.width),
        _forgotPassword(),
        _buttonSingIn(),
        _register()
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
              _register()
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _form(_screenSize.width * .6),
              _forgotPassword(),
              _buttonSingIn(),
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
        Navigator.of(context).canPop() ?
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 36,
            ), 
            onPressed: () => Navigator.pop(context)
          )
        : SizedBox(height: 36,)  ,
      ],
    );
  }

  Widget _logo(double alto){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Image(
        height: alto,
        image: new AssetImage('assets/img/logo.png'),
        color: Colors.white,
      ),
    );
  }

  Widget _form(double width){
    return Stack(
      alignment: Alignment(0.0, 1.3),
      overflow: Overflow.visible,
      children: <Widget>[
        _formSignIn(width * .8),
        _loginButton(),
      ],
    );
  }

  Widget _formSignIn(double width){
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
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _loginBloc.emailStream,
                builder: (context, snapshot) {
                  return TextField(
                    onChanged: _loginBloc.changeEmail,
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
                        size: 22.0,
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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
              padding: EdgeInsets.only(top: 20.0, bottom: 40.0, left: 25.0, right: 25.0),
              child: StreamBuilder<String>(
                stream: _loginBloc.passStream,
                builder: (context, snapshot) {
                  return TextField(
                    obscureText: true,
                    onChanged: _loginBloc.changePass,
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
                        size: 22.0,
                        color: Colors.black,
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
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

  Widget _loginButton(){
    return Container(
      decoration: Theme.Colors.myBoxDecButton,
      child: MaterialButton(
        onPressed: (){},
        child: _buttonState(),
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
      stream: _loginBloc.formValidStream,
      builder: (context, snapshot) {
        return MaterialButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "ENTRAR",
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
            ? () => _login( loginType.NORMAL, email:  _loginBloc.email, pass: _loginBloc.pass)
            : null
        );
      }
    );
  }

  Future<void> _login(loginType type, {String email, String pass}) async {

    await Provider.of<LoginRepository>(context, listen: false)
      .login(
        type,
        email: email,
        pass: pass
      );

    _showSnackBar();

  }

  _showSnackBar() async{
    
    LoginResponse _response = Provider.of<LoginRepository>(context, listen: false).getResponse();

    //SI no hay error redirige al home
    if(!_response.error) {
      
      String url = '/';

      if (widget.redirectUrl != null) url = widget.redirectUrl;
      
      Navigator.of(context).pushNamedAndRemoveUntil(url, (Route<dynamic> route) => false);
      //Navigator.of(context).pushNamed(url);
    }

    //Si hay un error mostrara un error
    else{
      var _snackBar = SnackBar(
        content: Text(_response.errorMessage)
      );

      _scaffoldstate.currentState.showSnackBar(_snackBar);
    }
  }

  Widget _forgotPassword(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: FlatButton(
        onPressed: () => Navigator.of(context).pushNamed('/resetEmail'),
        child: Text(
          "Olvidaste el Password?",
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansMedium"
          ),
        )
      ),
    );
  }

  Widget _buttonSingIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, right: 40.0),
          child: GestureDetector(
            onTap: () => _login(loginType.FACEBOOK),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Icon(
                FontAwesomeIcons.facebookF,
                color: Color(0xFF0084ff),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: GestureDetector(
            onTap: () => _login(loginType.GOOGLE),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Icon(
                FontAwesomeIcons.google,
                color: Color(0xFF0084ff),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _register(){
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '¿Aún no tienes cuenta?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: "WorkSansMedium"
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pushNamed('/register'),
            child: Text(
              "Crea una!",
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