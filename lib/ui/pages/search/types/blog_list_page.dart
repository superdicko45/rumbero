import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';
import 'package:rumbero/ui/widgets/search/blog_widget.dart';

import 'package:rumbero/logic/blocs/search/types/blogs_list_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';

class BlogsListPage extends StatefulWidget {

  const BlogsListPage({Key key});

  @override
  _BlogsListPageState createState() => _BlogsListPageState();
}

class _BlogsListPageState extends State<BlogsListPage> {
  
  BlogsListBloc _searchBloc = new BlogsListBloc();

  @override
  void initState() {
    _searchBloc.loadMore();
    super.initState();
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
        title: Text('Entradas al Blog')
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
          child: StreamBuilder<List<BlogModelResponse>>(
            stream: _searchBloc.blogsStream,
            builder: (context, snapshot){

              if (snapshot.hasData){

                List<BlogModelResponse> _blogs = snapshot.data;

                if(_blogs.length > 0)
                  return ListView.builder(
                    itemCount: _blogs.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return BlogResult(blog: _blogs[index]);
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