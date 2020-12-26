import 'package:flutter/material.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:intl/intl.dart';

import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';

class BlogResult extends StatelessWidget {

  final BlogModelResponse blog;

  const BlogResult({@required this.blog});

  @override
  Widget build(BuildContext context) {

    final String _tagId = UniqueKey().toString();
    var inicioO = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(blog.createdAt);
    var formatter = new DateFormat('EEE d MMMM', 'es_ES');
    String inicioD = formatter.format(inicioO);

    final List<String> _params = [
      _tagId,
      blog.blogId.toString(),
      blog.imagen,
      blog.titulo
    ];
    
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
        ),
        elevation: 7.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: ListTile(
          onTap: () => Navigator.pushNamed(
            context, 
            '/blog',
            arguments: _params   
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          leading: imageCover(blog.imagen),
          title: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        blog.titulo,
                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.Colors.loginGradientStart, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Text(inicioD),
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Theme.Colors.loginGradientEnd, size: 30.0)
        )
      ),
    );
  }

  Widget imageCover(String url){
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20)
      ),
      child: FadeInImage(
        width: 100,
        height: 300,
        image: NetworkImage(url),
        placeholder: AssetImage('assets/img/tempo.gif'),
        fit: BoxFit.cover,
      ),
    );
  }

}