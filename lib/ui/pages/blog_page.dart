import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:intl/date_symbol_data_local.dart';

import 'package:rumbero/logic/entity/models/blog_model.dart';

import 'package:rumbero/logic/blocs/bloc/blog_bloc.dart';
import 'package:rumbero/ui/widgets/blog/comments_widget.dart';
import 'package:rumbero/ui/widgets/blog/flexible_appbar_widget.dart';
import 'package:rumbero/ui/widgets/blog/info_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class BlogPage extends StatefulWidget {
  final dynamic params;

  const BlogPage({@required this.params});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  BlogBloc blogBloc = new BlogBloc();
  TabController tController;
  ScrollController sVController;

  void initState() {
    super.initState();
    blogBloc.showBlog(widget.params[1]);
    initialDate();
    tController = new TabController(length: 2, vsync: this);
    sVController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    super.dispose();
    blogBloc.dispose();
    tController.dispose();
    sVController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            controller: sVController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[myAppBar()];
            },
            body: StreamBuilder<Blog>(
                stream: blogBloc.blogController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return customTabView(snapshot.data);
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }

  Future<void> initialDate() async {
    await initializeDateFormatting('es_ES');
  }

  Widget myAppBar() {
    Size screenSize = MediaQuery.of(context).size;

    return SliverAppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => Share.share(
              'https://rumbero.live/blogs/show/' + widget.params[1],
              subject: 'Mira esto'),
        ),
      ],
      backgroundColor: Theme.Colors.loginGradientStart,
      pinned: true,
      expandedHeight: screenSize.height * 0.25,
      flexibleSpace: FlexibleSpaceBar(
        background: CustomFlexibleAppBar(
          tagId: widget.params[0],
          urlImage: widget.params[2],
          title: widget.params[3],
        ),
      ),
      bottom: customTabBar(),
    );
  }

  Widget customTabBar() {
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

  Widget customTabView(Blog blog) {
    return TabBarView(
      children: [
        blog.error ? _empty() : mainInfoBlog(blog),
        CommentsPage(blogId: blog.blogId),
      ],
      controller: tController,
    );
  }

  Widget _empty() {
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(
          flex: 4,
          child: NoInfo(
            svg: 'events.svg',
            text: 'Ocurrió un problema al cargar el blog',
          )),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: _orientation != Orientation.landscape
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
                backgroundColor: Theme.Colors.loginGradientStart,
                icon: Icon(
                  Icons.autorenew,
                  color: Colors.white,
                ),
                label: Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => blogBloc.showBlog(widget.params[1]))
          ],
        ),
      )
    ];

    return _orientation != Orientation.landscape
        ? Column(
            children: _items,
          )
        : Row(
            children: _items,
          );
  }

  Widget mainInfoBlog(Blog blog) {
    var fecha = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(blog.createdAt);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');

    String _fecha = formatter.format(fecha);

    return InfoBlog(blog: blog, fecha: _fecha);
  }
}
