import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/search/academy_widget.dart';

import 'package:rumbero/logic/blocs/search/types/schools_list_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/academy_model_response.dart';

class SchoolsListPage extends StatefulWidget {

  final dynamic params;

  const SchoolsListPage({Key key, this.params});

  @override
  _SchoolsListPageState createState() => _SchoolsListPageState();
}

class _SchoolsListPageState extends State<SchoolsListPage> {
  
  SchoolsListBloc _searchBloc = new SchoolsListBloc();

  @override
  void initState() {
    super.initState();
    _searchBloc.initLoad(widget.params);
  }

  @override
  void dispose() {
    super.dispose();
    _searchBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.loginGradientEnd,
        title: Text('Lista de academias')
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<bool>(
      stream: _searchBloc.isLoadingStream,
      initialData: false,
      builder: (context, snapshot) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if(
              !snapshot.data &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              scrollInfo is ScrollEndNotification
            )
              _searchBloc.loadMore();

            return true;
          },
          child: StreamBuilder<List<AcademyModelResponse>>(
            stream: _searchBloc.schoolStream,
            builder: (context, snapshot){

              if (snapshot.hasData){

                List<AcademyModelResponse> _schools = snapshot.data;

                if(_schools.length > 0)
                  return ListView.builder(
                    itemCount: _schools.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return AcademyResult(academia : _schools[index]);
                    }
                  );

                else
                  return NoInfo(svg: 'events.svg', text: 'Sin resultados',);
              }
              
              else return _searching();

            },
          ),
        );
      }
    );
  
  }

  Widget _searching() {
    return Center(child: CircularProgressIndicator());
  }

}