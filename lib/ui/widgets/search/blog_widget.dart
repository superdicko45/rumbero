import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';

class BlogResult extends StatelessWidget {

  final BlogModelResponse blog;

  const BlogResult({@required this.blog});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: _card(context, _screenSize, blog)
    );
  }

  Widget _card(BuildContext context, Size size, BlogModelResponse blog){

    final String _tagId = UniqueKey().toString();
    final _orientation = MediaQuery.of(context).orientation;

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
          bottomLeft: Radius.circular(30)
        )
      ),
      elevation: 7.0,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(
            context, 
            '/blog',
            arguments: _params
          );
        },
        child: Column(
          children: <Widget>[
            Container(
              height: _orientation == Orientation.landscape 
                ? size.height * .5 
                : size.height * .3,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                ),
                child: Hero(
                  tag: _tagId,
                  child: FadeInImage(
                    image: NetworkImage(blog.imagen),
                    placeholder: AssetImage('assets/img/tempo.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              )    ,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: footer(blog),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget footer(BlogModelResponse blog){

    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(blog.createdAt);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');
    String inicioD = formatter.format(inicioO);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(height: 8.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(blog.fotoPerfil)
                  ),
                  SizedBox(width: 10.0),
                  Text(blog.username, style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12.0
                  ))
                ],
              ),
              Text(inicioD, style: TextStyle(
                color: Colors.black38,
                fontSize: 12.0
              )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(blog.titulo, style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            )
          ),
        ),
      ],
    );
  }

}