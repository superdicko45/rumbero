import 'package:rumbero/logic/entity/models/search_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/blocs/search/search_bloc.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/logic/entity/responses/search_response.dart';
import 'package:flutter/material.dart';

import 'package:rumbero/ui/widgets/search/results_widget.dart';

class ResultsPage extends StatefulWidget {
  final Search filtro;

  const ResultsPage({Key key, this.filtro}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  SearchBloc _searchBloc = new SearchBloc();
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc.initLoad(widget.filtro);

    if (widget.filtro != null) changeInput(widget.filtro.q ?? '');

    _searchBloc.suggeStream;
    _searchBloc.resultStream;
    _searchBloc.stateStream;
  }

  @override
  void dispose() {
    super.dispose();
    _searchBloc.dispose();
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: _body(),
      floatingActionButton: _myFAB(),
    );
  }

  void changeInput(String newText) {
    this.setState(() {
      myController.text = newText;
    });
  }

  void search(String q) {
    _searchBloc.search(q);
  }

  Future<void> _filtrar() async {
    Search _response = _searchBloc.getFilter(myController.text);
    Navigator.pushNamed(context, '/filter', arguments: _response);
  }

  Widget _body() {
    return StreamBuilder<stateType>(
      stream: _searchBloc.stateStream,
      initialData: stateType.TIPYNG,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.data) {
          case stateType.TIPYNG:
            return _suggestions();
            break;
          case stateType.SEARCHING:
            return _searching();
            break;
          case stateType.RESULTS:
            return _results();
            break;
          default:
            return _waiting();
        }
      },
    );
  }

  Widget _waiting() {
    return StreamBuilder<List<String>>(
      stream: _searchBloc.histoStream,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data.isNotEmpty
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      search(snapshot.data[index]);
                      changeInput(snapshot.data[index]);
                    },
                    leading: Icon(Icons.av_timer),
                    title: Text(snapshot.data[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: () => changeInput(snapshot.data[index]),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget _results() {
    return StreamBuilder<SearchResponse>(
        stream: _searchBloc.resultStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //si no hay resultados
            if (snapshot.data.error) {
              return NoInfo(
                svg: 'events.svg',
                text: 'Sin resultados',
              );
            } else {
              final Search filtro = _searchBloc.getFilter(myController.text);
              return Results(
                response: snapshot.data,
                filtro: filtro,
              );
            }
          } else
            return Container();
        });
  }

  Widget _searching() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _myFAB() {
    return FloatingActionButton.extended(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        label: Text(
          'Buscar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.Colors.loginGradientEnd,
        onPressed: () => search(myController.text));
  }

  Widget _suggestions() {
    return StreamBuilder<List<String>>(
        stream: _searchBloc.suggeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> results = snapshot.data;

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    search(results[index]);
                    changeInput(results[index]);
                  },
                  leading: Icon(Icons.access_time),
                  title: Text(results[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () => changeInput(results[index]),
                  ),
                );
              },
            );
          } else {
            return Center();
          }
        });
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pushNamed('/'),
      ),
      backgroundColor: Theme.Colors.loginGradientEnd,
      title: TextFormField(
          onChanged: (q) => _searchBloc.suggestions(q),
          controller: myController,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
              hintText: 'Buscar...',
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Theme.Colors.loginGradientStart.withOpacity(0.1),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white54,
                ),
                onPressed: () {
                  changeInput('');
                  _searchBloc.clean();
                },
              ))),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.tune), onPressed: () => _filtrar()),
      ],
    );
  }
}
