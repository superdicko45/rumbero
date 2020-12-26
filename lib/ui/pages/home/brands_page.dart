import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

//import 'package:rumbero/ui/widgets/noInfo_widget.dart';


class BrandsPage extends StatefulWidget {
  const BrandsPage({Key key}) : super(key: key);

  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> with AutomaticKeepAliveClientMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body(context);
  }

  @override
  bool get wantKeepAlive => true;
    
  Widget _body(context){
    
    return _main();
  }

  Widget _main(){
    return ListView(
      children: <Widget>[
        _header('Las mejores marcas para ti'),
        _filter(),
        SizedBox(height: 30,),
        _brandsLayout(),
        SizedBox(height: 10,)
      ],
    );
  }

  Widget _filter(){

    List<String> _categories = ['Todo', 'Calzado', 'Vestimenta', 'Varios'];

    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ChoiceChip(
            label: Text(_categories[index]), 
            labelStyle: index == 1
              ? TextStyle(color: Colors.white)
              : null,
            selectedColor: Theme.Colors.loginGradientStart,
            backgroundColor: Colors.white10,
            selected: index == 1 ? true : false,
            onSelected: (bool value) => {}
          )
        );
       },
      ),
    );
  }

  Widget _header(String title){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,
            style: new TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 19.0,
              letterSpacing: 1.0
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandsLayout(){

    List<String> images = [
      'assets/img/b1.jpg',
      'assets/img/b2.jpg',
      'assets/img/b3.jpg',
      'assets/img/b4.jpg',
      'assets/img/b1.jpg',
      'assets/img/b2.jpg',
      'assets/img/b3.jpg',
      'assets/img/b4.jpg',
    ];

    return Wrap(
      children: List.generate(images.length, (index) => _brand(images[index])),
    );
  }

  Widget _brand(String image){

    String tagId = UniqueKey().toString();
    String url   = 'algo';

    final List<String> _params = [
      image,
      tagId,
      url
    ];

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context, 
          '/articles',
          arguments: _params   
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60 ) / 2,
        height: (MediaQuery.of(context).size.height ) / 5,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30)
          ),
          child: Hero(
            tag: tagId,
            child: FadeInImage(
              image: AssetImage(image),
              placeholder: AssetImage('assets/img/tempo.gif'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

}