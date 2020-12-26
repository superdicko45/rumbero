import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/search/filter_bloc.dart';
import 'package:rumbero/logic/entity/models/search_model.dart';
import 'package:rumbero/logic/entity/models/general_model.dart';

class FilterPage extends StatefulWidget {

  final Search filtro;

  const FilterPage({Key key, this.filtro}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  FilterBloc _filterBloc = new FilterBloc();

  @override
  void initState() { 
    super.initState();
    _filterBloc.loadData(widget.filtro);
  }

  @override
  void dispose() {
    _filterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.loginGradientEnd,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _iTipo(),
                _iCiudad(),
                _iRango(),
                _iGeneros(),
                _body(),
              ],
            ),
          ),
          _button()
        ],
      ),
    );
  }

  Future<void> _filtrar() async {
    Search _response = await _filterBloc.filtrar();
    Navigator.popAndPushNamed ( context, '/results', arguments: _response, );
  }

  Widget _iTipo(){

    Map<int, String> _items = {1:'Todos', 2:'Eventos', 3:'Academias', 4:'Usuarios'};
    List<DropdownMenuItem<int>> _list = new List<DropdownMenuItem<int>>();

    _items.forEach((k, v) => _list.add( DropdownMenuItem<int>(value: k, child: Text(v) )));

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'MOSTRAR'
          ),
          StreamBuilder<int>(
            stream: _filterBloc.tipoStream,
            builder: (context, snapshot) {

              if(snapshot.hasData)
                return DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: snapshot.data,
                    isDense: true,
                    onChanged: (int _newValue) => _filterBloc.changeTipo(_newValue),
                    items: _list
                  )
                );
              else return SizedBox();  
            }
          ),
        ],
      )  
    );
  }

  Widget _iCiudad(){

    return StreamBuilder<List<General>>(
      stream: _filterBloc.cDispStream,
      builder: (context, snapshot) {

        if(snapshot.hasData) {

          List<General> _ciudades = snapshot.data;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CIUDAD'
                ),
                StreamBuilder<int>(
                  stream: _filterBloc.ciudadStream,
                  builder: (context, snapshot) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: snapshot.data,
                        isDense: true,
                        onChanged: (int _newValue) => _filterBloc.changeCiudad(_newValue),
                        items: _ciudades.map((General _item) {
                          return DropdownMenuItem<int>(
                            value: _item.itemId,
                            child: Text(_item.item,),
                          );
                        }).toList()
                      )
                    );
                  }
                ),
              ],
            )  
          );
        }
        else return SizedBox();  
      }
    );
  }

  Widget _iRango(){

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<List<double>>(
        stream: _filterBloc.rangeStream,
        initialData: [100, 500],
        builder: (context, snapshot) {

          double min = snapshot.data[0];
          double max = snapshot.data[1];

          return Column(
            children: [
              Text(
                'PRECIO'
              ),
              RangeSlider(
                activeColor: Theme.Colors.loginGradientEnd,
                min: 0,
                max: 1000,
                values: RangeValues(min, max), 
                divisions: 100,
                labels: RangeLabels(min.toString(), max.toString()),
                onChanged: (value) => _filterBloc.changeRan([value.start, value.end])
                
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${min.toString()}'
                    ), 
                    Text(
                      '\$${max.toString()}'
                    ),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget _iGeneros(){

    return StreamBuilder<List<General>>(
      stream: _filterBloc.gDispStream,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          List<General> _generos = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'GENEROS'
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: _generos.map((General item) {
                        return _chipGenero(item);
                      }).toList(),
                    )
                  ),
                ),
              ],
            ),
          );
        }
        else return SizedBox();
      }
    );
  }

  Widget _chipGenero(General item){
    return StreamBuilder<List<int>>(
      stream: _filterBloc.generosStream,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          bool _selected = snapshot.data.contains(item.itemId);

          return Container(
            padding: EdgeInsets.all(3.0),
            child: ChoiceChip(
              label: Text(item.item), 
              labelStyle: _selected
                ? TextStyle(color: Colors.white)
                : null,
              selectedColor: Theme.Colors.loginGradientEnd,
              selected: _selected,
              onSelected: (bool value) => _filterBloc.changeGenero(item.itemId, value)
            ),
          );
        } else return SizedBox();
      }
    );
  }

  Widget _body(){
    return StreamBuilder<int>(
      stream: _filterBloc.tipoStream,
      builder: (context, snapshot) {

        if(snapshot.data == 2) //eventos
          return Column(
            children: [
              _iDateP(context),
              _iTipoEvent()
            ],
          );

        else if (snapshot.data == 3) //academias
          return _iServicios();

        else return SizedBox();   
      }
    );
  }

  Widget _iDateP(BuildContext context){
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return MaterialButton(
          color: Theme.Colors.loginGradientStart,
          textColor: Colors.white70,
          onPressed: () async {
            final List<DateTime> picked = await DateRagePicker.showDatePicker(
              context: context,
              firstDate: new DateTime.now(),
              lastDate: new DateTime.now().add(new Duration(days: 200)),          
              initialFirstDate: new DateTime.now(),
              initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
            );
            if (picked != null) {
              _filterBloc.changeMinD(picked[0]);
              if(picked[1] != null) _filterBloc.changeMaxD(picked[1]);
            }
          },
          child: new Text("Seleccionar fecha")
        );
      }
    );
  }

  Widget _iTipoEvent(){

    Map<int, String> _items = {0:'Todos', 1:'Sociales', 2:'Talleres', 3:'Congresos'};
    List<DropdownMenuItem<int>> _list = new List<DropdownMenuItem<int>>();

    _items.forEach((k, v) => _list.add( DropdownMenuItem<int>(value: k, child: Text(v) )));

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TIPO DE EVENTO'
          ),
          StreamBuilder<int>(
            stream: _filterBloc.tipoEStream,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                return DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: snapshot.data,
                    isDense: true,
                    onChanged: (int _newValue) => _filterBloc.changeTipoE(_newValue),
                    items: _list
                  )
                );
              else return SizedBox();
            }
          ),
        ],
      )  
    );
  }

  Widget _iServicios(){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'SERVICIOS DE LAS ACADEMIAS'
          ),
          ListTile(
            title: Text('Online'),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('Una opción que te permite encontrar academias con clases online.'),
            ),
            trailing: StreamBuilder<bool>(
              stream: _filterBloc.onlineStream,
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  return Switch(
                    value: snapshot.data,
                    onChanged: (value) => _filterBloc.changeOnline(value),
                    activeTrackColor: Theme.Colors.loginGradientEnd.withOpacity(0.5),
                    activeColor: Theme.Colors.loginGradientEnd,
                  );
                return SizedBox();  
              }
            )
          ),
          ListTile(
            title: Text('Entre semana'),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('Encuentra academias que se acoplen a tu ritmo de vida.'),
            ),
            trailing: StreamBuilder<bool>(
              stream: _filterBloc.weekStream,
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  return Switch(
                    value: snapshot.data,
                    onChanged: (value) => _filterBloc.changeWeek(value),
                    activeTrackColor: Theme.Colors.loginGradientEnd.withOpacity(0.5),
                    activeColor: Theme.Colors.loginGradientEnd,
                  );
                else return SizedBox();  
              }
            )
          ),
          ListTile(
            title: Text('Fines de semana'),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text('Si tus tiempos no te permiten practicar entre semana, deberias intentar esta opción.'),
            ),
            trailing: StreamBuilder<bool>(
              stream: _filterBloc.weekendStream,
              builder: (context, snapshot) {
                if(snapshot.hasData)
                  return Switch(
                    value: snapshot.data,
                    onChanged: (value) => _filterBloc.changeWeekend(value),
                    activeTrackColor: Theme.Colors.loginGradientEnd.withOpacity(0.5),
                    activeColor: Theme.Colors.loginGradientEnd,
                  );
                else return SizedBox();  
              }
            )
          )
        ],
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60),
      child: Container(
        decoration: Theme.Colors.myBoxDecButton,
        child: MaterialButton(
          onPressed: (){},
          child: MaterialButton(
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
            onPressed: () => _filtrar()
          )
        )
      ),
    );
  }
}