import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/search/user_widget.dart';

import 'package:rumbero/logic/blocs/search/types/users_list_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/user_model_response.dart';

class UsersListPage extends StatefulWidget {

  final dynamic params;

  UsersListPage({Key key, this.params});

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

  UsersListBLoc _searchBloc = new UsersListBLoc();

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
          child: StreamBuilder<List<UserModelResponse>>(
            stream: _searchBloc.usersTream,
            builder: (context, snapshot){

              if (snapshot.hasData){

                List<UserModelResponse> _users = snapshot.data;

                if(_users.length > 0)
                  return ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return UserResult(user : _users[index]);
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