import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/models/category_model.dart';
import 'package:rumbero/logic/entity/models/search_model.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class CardSwiper extends StatelessWidget {

  final List<Category> categorias;

  const CardSwiper({@required this.categorias});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 150,
      child: LayoutBuilder(builder: (context, contraint){
        return ListView.builder(
          padding: EdgeInsets.all(5.0),
          scrollDirection: Axis.horizontal,
          itemCount: categorias.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return card(categorias[index], ctxt);
          }  
        );
      }) 
    );
  }

  Widget card(Category category, BuildContext context){

    Search _filtro = new Search(categorias: [category.generoId], filtro: true);

    return InkWell(
      onTap: () => Navigator.pushNamed( context, '/results', arguments: _filtro ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget> [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(category.imagen),
                placeholder: AssetImage('assets/img/tempo.gif'),
                fit: BoxFit.cover,
                height: 130,
                width: 130,
              )     
            ),
            Container(
              height: 130,
              width: 130,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Theme.Colors.loginGradientEnd.withOpacity(0.0),
                    Theme.Colors.loginGradientStart,
                  ],
                  stops: [
                    0.2,
                    1.0
                  ]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    category.genero,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}