import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/entity/models/general_model.dart';
import 'package:rumbero/logic/entity/profile/my_user_model.dart';
import 'package:rumbero/logic/blocs/profile/edit_bloc.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  EditBloc _editBloc = new EditBloc();

  @override
  void initState() {
    super.initState();
    _editBloc.showUser();
    _editBloc.nameStream;
    _editBloc.nickStream;
    _editBloc.descStream;
    _editBloc.tipoStream;
    _editBloc.geneStream;
  }  

  @override
  void dispose(){
    editBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text('Editar perfil'),
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: StreamBuilder<MyUser>(
        stream: _editBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            final MyUser user = snapshot.data;

            return ListView(
              children: <Widget>[
                _iNombre(user.nombre),
                _iUsername(user.username),
                _iDescripcion(user.descripcion),
                _iTipo(user.tipDisponibles),
                _iGeneros(context, user.catDisponibles),
                _buttonSave()
              ],
            );
          }
          else 
            return Center(
              child: CircularProgressIndicator()
            );
        }
      )
    );
  }

  Future<void> _saveData() async{
    
    Map _response = await _editBloc.saveData();
    _showSnackBar(_response["msg"], _response["error"]);    
  }

  _showSnackBar(String _text, bool _error) async{
    
    var _snackBar = SnackBar(
      content: Text(_text)
    );

    _scaffoldstate.currentState.showSnackBar(_snackBar);
  }

  Future<void> _showDialog(BuildContext context, List<General> _items) async {

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>_alert(_items)
    );
  }

  
  Widget _iNombre(String nombre){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
      child: StreamBuilder<String>(
        stream: _editBloc.nameStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: nombre,
            onChanged: _editBloc.changeName,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              labelText: "Nombre de usuario *",
              fillColor: Colors.white,
              icon: Icon(Icons.person_pin),
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
      ),
    );
  }

  Widget _iUsername(String nick){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<String>(
        stream: _editBloc.nickStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: nick != null ? nick : null,
            onChanged: _editBloc.changeNick,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              helperStyle: TextStyle(color: Colors.green),
              labelText: "Nickname *",
              fillColor: Colors.white,
              icon: Icon(Icons.face),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: new BorderSide(
                  color: Theme.Colors.loginGradientStart
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            maxLength: 25,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          );
        }
      ),
    );
  }

  Widget _iDescripcion(String descripcion){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: StreamBuilder<String>(
        stream: _editBloc.descStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: descripcion,
            onChanged: _editBloc.changeDesc,
            decoration: new InputDecoration(
              errorText: snapshot.error,
              labelText: "Descripción *",
              fillColor: Colors.white,
              hintText: 'Cuentanos mas de ti',
              icon: Icon(Icons.description),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: new BorderSide(
                  color: Theme.Colors.loginGradientStart
                ),
              ),
            ),
            keyboardType: TextInputType.text,
            maxLines: 5,
            maxLength: 500,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          );
        }
      ),
    );
  }

  Widget _iTipo(List<General> _items){

    return Padding(
      padding: EdgeInsets.all(16),
      child: InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.group_work),
          labelText: 'Con cual te identificas mas?',
        ),
        child: StreamBuilder<int>(
          stream: _editBloc.tipoStream,
          builder: (context, snapshot) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: snapshot.data,
                isDense: true,
                onChanged: (int _newValue){
                  _editBloc.changeTipo(_newValue);
                },
                items: _items.map((General _tipo) {
                  return DropdownMenuItem<int>(
                    value: _tipo.itemId,
                    child: Text(_tipo.item),
                  );
                }).toList(),
              )
            );
          }
        ),
      ),
    );
  }

  Widget _iGeneros(BuildContext context, List<General> _items){
    return ListTile(
      leading: Icon(Icons.grain),
      title: Text('Mis generos son: '),
      subtitle: StreamBuilder<List<int>>(
        stream: _editBloc.geneStream,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            
            String _cantidad = snapshot.data.length.toString();
            return Text('$_cantidad Items');
          } 
          else 
            return Text('0 Items');
        }
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => _showDialog(context, _items),
    );
  }

  Widget _alert(List<General> _items){

    return AlertDialog(
      scrollable: true,
      title: Text('Mis actuales generos'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('Cerrar')
        )
      ],
      content: Container(
        child: SingleChildScrollView(
          child: StreamBuilder<List<int>>(
            stream: _editBloc.geneStream,
            builder: (context, snapshot) {

              if(snapshot.hasData)
                return Wrap(
                  children: _choiceChips(_items, snapshot.data)
                );
              else
                return Center(
                  child: Text('Sin generos'),
                );  
            }
          ),
        ),
      ),
    );
  }

  List<Widget> _choiceChips(List<General> _items, List<int> _actuales){

    List<Widget> _chips = new List<Widget>();

    _items.forEach((element) { 

      bool _selected = _actuales.contains(element.itemId);

      _chips.add(
        Container(
          padding: EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(element.item), 
            labelStyle: _selected
              ? TextStyle(color: Colors.white)
              : null,
            selectedColor: Theme.Colors.loginGradientStart,
            selected: _selected,
            onSelected: (bool value) => _editBloc.changeGenero(element.itemId, value)
          ),
        )
      );
    });

    return _chips;
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
      stream: _editBloc.stateStream ,
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
      stream: _editBloc.formValidStream,
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

}
