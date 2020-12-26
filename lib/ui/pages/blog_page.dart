import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/models/blog_model.dart';

import 'package:rumbero/logic/blocs/bloc/blog_bloc.dart';
import 'package:rumbero/ui/widgets/blog/comments_widget.dart';
import 'package:rumbero/ui/widgets/blog/flexible_appbar_widget.dart';
import 'package:rumbero/ui/widgets/blog/info_widget.dart';

class BlogPage extends StatefulWidget {

  final dynamic params;

  const BlogPage({@required this.params});  

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with SingleTickerProviderStateMixin{

  BlogBloc blogBloc = new BlogBloc();
  TabController tController;
  ScrollController sVController;

  void initState() {
    super.initState();
    blogBloc.showBlog(widget.params[1]);
    tController = new TabController(length: 2, vsync: this);
    sVController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose(){
    blogBloc.dispose();
    tController.dispose();
    sVController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
        controller: sVController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            myAppBar()
          ];
        },
        body: StreamBuilder<Blog>(
          stream: blogBloc.subject.stream,
          builder: (context, snapshot) {
            if(snapshot.hasData)
              return customTabView(snapshot.data);
            return Center(child: CircularProgressIndicator(),);
          }
        )
      )  
    );
  }

  
  Widget myAppBar(){

    Size screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Theme.Colors.loginGradientStart,
      pinned: true,
      expandedHeight: screenSize.height * 0.25,
      flexibleSpace: FlexibleSpaceBar(
          background: CustomFlexibleAppBar(
            tagId : widget.params[0],
            urlImage: widget.params[2],
            title: widget.params[3],
          ),
        ),
      bottom: customTabBar(),  
    );
  }

  Widget customTabBar(){

    return TabBar(
      controller: tController,
      tabs: <Widget>[
        Tab(
          icon: new Icon(Icons.info),
          text: 'Contenido',
        ),
        Tab(
          icon: new Icon(Icons.message),
          text: 'Comentarios',
        ),
      ],
    );
  }

  Widget customTabView(Blog blog){
    return TabBarView(
      children: [
        InfoBlog(blog: blog),
        CommentsPage(blogId: blog.blogId),
      ],
      controller: tController,
    );
  }

}