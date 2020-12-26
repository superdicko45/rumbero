import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/home/home_bloc.dart';
import 'package:rumbero/logic/entity/model_reponses/video_model_response.dart';

import 'package:rumbero/logic/entity/models/category_model.dart';
import 'package:rumbero/logic/entity/model_reponses/event_model_response.dart';
import 'package:rumbero/logic/entity/model_reponses/blog_model_response.dart';
import 'package:rumbero/logic/entity/responses/home_response.dart';

import 'package:rumbero/ui/widgets/card_slider_widget.dart';
import 'package:rumbero/ui/widgets/home/blog_slider_widget.dart';
import 'package:rumbero/ui/widgets/home/card_swiper_widget.dart';
import 'package:rumbero/ui/widgets/home/videos_swiper_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  HomeBloc homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.getData();
  }

  @override
  void dispose(){
    homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body(context);
  }

  @override
  bool get wantKeepAlive => true;

  Widget _videos(List<VideoModelResponse> videos){
    
    return videos.isNotEmpty 
      ? VideosSwiper(videos: videos)
      : _emptyText(); 
  }

  Widget _blogs(List<BlogModelResponse> blogs){
    
    return blogs.isNotEmpty 
      ? BlogSlider(blogs: blogs)
      : _emptyText(); 
  }

  Widget _categorias(List<Category> categorias){

    return categorias.isNotEmpty
      ? CardSwiper(categorias: categorias)
      : _emptyText();
  }

  Widget _recomendados(List<EventModelResponse> eventos){
    
    return eventos.isNotEmpty 
      ? CardSlider(events: eventos)
      : _emptyText(); 
  }

  Widget _loader(){
    return Center(
      child: CircularProgressIndicator(),
    );  
  }

  Widget _body(context){
    
    return RefreshIndicator(
      onRefresh: homeBloc.getData,
      child: StreamBuilder<HomeResponse>(
        stream: homeBloc.subject.stream,
        builder: (context, snapshot) {
          return snapshot.hasData 
            ? _main(snapshot.data)
            : _loader();
        }
      ),
    );
  }

  Widget _main(HomeResponse homeResponse){
    return !homeResponse.error 
      ? ListView(
          children: <Widget>[
            _header('Categorias principales'),
            _categorias(homeResponse.categories),
            _header('Nuestra recomendación!'),
            _recomendados(homeResponse.recomendados),
            _header('Te recomendamos ver'),
            _videos(homeResponse.videos),
            _headerWithLink('Entradas recientes al blog!', '/results_blogs'),
            _blogs(homeResponse.blogs),
            SizedBox(height: 10,)
          ],
        )
      : _empty();        
  }

  Widget _empty() {
    
    return Center(
      child: NoInfo(svg: 'events.svg', text: 'Algo sucedio',),
    );
  }

  Widget _headerWithLink(String header, String route){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _header(header),
        InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ver todo',
              style: TextStyle(
                color: Theme.Colors.loginGradientEnd,
                fontSize: 15.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
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

  Widget _emptyText(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Sin resultados, intenta volver a recargar!',
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              letterSpacing: 1.0
            ),
          ),
        ],
      ),
    );
  }

}