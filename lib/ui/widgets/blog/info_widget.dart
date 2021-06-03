import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/models/blog_model.dart';

class InfoBlog extends StatelessWidget {
  final Blog blog;
  final String fecha;

  const InfoBlog({this.fecha, @required this.blog});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        mainInfo(blog.fotoPerfil, blog.username, fecha),
        content(blog.contenidos)
      ],
    );
  }

  Widget mainInfo(String image, String nickname, String date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.black45),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(image),
                maxRadius: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(nickname,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black45)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget content(List<Contenidos> contenidos) {
    List<Widget> items = List<Widget>();

    for (var contenido in contenidos) {
      items.add(paragraph(contenido));
    }

    return Column(children: items);
  }

  Widget paragraph(Contenidos contenido) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        contenido.titulo != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                child: Text(contenido.titulo,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
          child: Text(contenido.descripcion,
              style: TextStyle(
                color: Colors.black54,
                wordSpacing: 2,
              )),
        ),
        contenido.imagen != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(contenido.imagen)),
              )
            : SizedBox()
      ],
    );
  }
}
