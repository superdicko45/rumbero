import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';

class BlogSlider extends StatelessWidget {
  final List<BlogModelResponse> blogs;

  const BlogSlider({@required this.blogs});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _orientation = MediaQuery.of(context).orientation;

    return Container(
        height: _orientation == Orientation.landscape
            ? _screenSize.height * .8
            : _screenSize.height * .5,
        child: LayoutBuilder(builder: (context, contraint) {
          return ListView.builder(
              padding: EdgeInsets.all(5.0),
              scrollDirection: Axis.horizontal,
              itemCount: blogs.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _card(contraint, ctxt, _screenSize, blogs[index]);
              });
        }));
  }

  Widget _card(BoxConstraints constraint, BuildContext context, Size size,
      BlogModelResponse blog) {
    final String _tagId = UniqueKey().toString();

    final List<String> _params = [
      _tagId,
      blog.blogId.toString(),
      blog.imagen,
      blog.titulo
    ];

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      elevation: 7.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/blog', arguments: _params);
        },
        child: Column(
          children: <Widget>[
            Container(
              height: constraint.maxHeight * .5,
              width: size.width * .7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                child: Hero(
                  tag: _tagId,
                  child: FadeInImage(
                    image: NetworkImage(blog.imagen),
                    placeholder: AssetImage('assets/img/tempo.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              height: constraint.maxHeight * .4,
              width: size.width * .7,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20)),
              ),
              child: footer(blog),
            )
          ],
        ),
      ),
    );
  }

  Widget footer(BlogModelResponse blog) {
    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(blog.createdAt);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');
    String inicioD = formatter.format(inicioO);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(backgroundImage: NetworkImage(blog.fotoPerfil)),
                  SizedBox(width: 10.0),
                  Text(blog.username,
                      style: TextStyle(color: Colors.black38, fontSize: 12.0))
                ],
              ),
              Text(inicioD,
                  style: TextStyle(color: Colors.black38, fontSize: 12.0)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(blog.titulo,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.message,
                color: Theme.Colors.loginGradientStart,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: blog.total > 0
                    ? Text(blog.total.toString() + ' comentarios')
                    : Text('Sin comentarios'),
              )
            ],
          ),
        )
      ],
    );
  }
}
