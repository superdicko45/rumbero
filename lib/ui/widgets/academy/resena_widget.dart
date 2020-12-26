import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rumbero/utils/timeformat.dart';

import 'package:rumbero/logic/repository/login_repository.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/blocs/academy/resena_bloc.dart';
import 'package:rumbero/logic/entity/models/academy_model.dart';
import 'package:rumbero/logic/entity/models/resena_model.dart';

class ResenaPage extends StatefulWidget {

  final Academia academia;

  const ResenaPage({
    Key key, 
    @required this.academia
  }) : super(key: key);

  @override
  _ResenaPageState createState() => _ResenaPageState();
}

class _ResenaPageState extends State<ResenaPage> with AutomaticKeepAliveClientMixin{

  final ResenaBloc _resenaBloc = new ResenaBloc();

  @override
  void initState() { 
    super.initState();
    _resenaBloc.initLoad(widget.academia);
    _resenaBloc.isLoadingController;
    _resenaBloc.resenasController;
  }

  @override
  void dispose() {
    super.dispose();
    _resenaBloc.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<Academia>(
      stream: _resenaBloc.academiaController.stream,
      builder: (context, snapshot) {
        if(snapshot.hasData)
          return _main(snapshot.data);
        else
          return Center(child: CircularProgressIndicator(),);  
      }
    );
  }

  Future<void> _showDialog(BuildContext context) async {

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>_alert()
    );
  }

  Future<void> _addResena() async {

    _resenaBloc.saveRating();
    Navigator.of(context).pop();
  }

  Widget _main(Academia _academia) {

    final _screenSize = MediaQuery.of(context).size;

    return StreamBuilder<bool>(
      stream: _resenaBloc.isLoadingController.stream,
      initialData: false,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            buttonReview(),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if(
                    !snapshot.data &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    scrollInfo is ScrollEndNotification
                  )
                    _resenaBloc.loadMore();

                  return true;
                },
                child: body( 
                  _academia.raking, 
                  _academia.total,
                  _academia.stars,
                  _screenSize.width - 180
                )
              )  
            )
          ],
        );
      }
    );
  }

  Widget _alert(){

    return AlertDialog(
      scrollable: true,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('Cerrar')
        ),
        FlatButton(
          color: Theme.Colors.loginGradientStart,
          onPressed: () => _addResena(), 
          child: Text('Enviar')
        )
      ],
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Te gusto la experiencia?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                onChanged: (String value) => _resenaBloc.changeResena(value),
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Dile algo a ${widget.academia.nombre}',
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                      color: Theme.Colors.loginGradientStart
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                maxLines: 5,
                maxLength: 200,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              RatingBar(
                itemSize: 40.0,
                unratedColor: Colors.black38,
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                ignoreGestures: false,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.Colors.loginGradientEnd,
                ),
                onRatingUpdate: (star) => _resenaBloc.changeStars(star),
              ),
              StreamBuilder<double>(
                stream: _resenaBloc.iResenaController.stream,
                initialData: 5,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data.toInt()} estrella(s)',
                    style: TextStyle(
                      color: Colors.black38
                    ),
                  );
                }
              )
            ],
          )
        ),
      ),
    );
  }

  Widget buttonReview(){

    bool isLogin = Provider.of<LoginRepository>(context).isLogin();

    return isLogin 
      ? StreamBuilder<bool>(
        stream: _resenaBloc.showAddButtonController.stream,
        initialData: true,
        builder: (context, snapshot) {

          if(snapshot.data)
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () => _showDialog(context),
                label: Text('Agregar reseña', style: TextStyle(color: Theme.Colors.loginGradientEnd)),
                icon: Icon(Icons.add_comment, color: Theme.Colors.loginGradientEnd,), 
                backgroundColor: Theme.Colors.loginGradientStart,
              ),
            );
          else return SizedBox();  
        }
      )
      :SizedBox();
  }

  Widget body(
    Map<String, dynamic> raking, 
    int total, 
    String stars, 
    double width
  ) {
    return StreamBuilder<List<Resena>>(
      stream: _resenaBloc.resenasController.stream,
      builder: (context, AsyncSnapshot<List<Resena>> snapshot) {
        
        if(snapshot.hasData && snapshot.data.length > 0) 
            return resenas(snapshot.data, raking, total,  stars, width);
        else 
          return NoInfo(svg: 'resena.svg', text: 'No pudimos encontrar reseñas de esta academia.');
      }
    );
  }

  Widget resenas(
    List<Resena> resenas, 
    Map<String, dynamic> raking, 
    int total, 
    String stars, 
    double width
  ){
    return ListView.builder(
      itemCount: resenas.length + 1,
      itemBuilder: (BuildContext context, int index) {
        
        if(index == 0) return calification(raking, total, stars, width);

        else return card(resenas[index - 1]);

      },
    );
  }

  Widget calification(Map<String, dynamic> raking, int total, String stars, double width){

    List<Widget> bars = new List<Widget>();

    for (var i = 1; i <= 5; i++) {

      int _cal = 0;

      if(raking.containsKey(i.toString())) {
      
        _cal = raking[i.toString()];
      }

      bars.add(rowCal(i.toString(), _cal, width, total));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: bars),
              cal(total, stars)
            ],
          ),
        ],
      ),
    );
  }

  Widget cal(int total, String calificacion){
    return Container(
      width: 120.0,
      child: Column(
        children: [
          Text(
            double.parse(calificacion).toStringAsFixed(1),
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold
            ),
          ),
          RatingBar(
            itemSize: 15.0,
            unratedColor: Colors.black38,
            initialRating: double.parse(calificacion).roundToDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.Colors.loginGradientEnd,
            ),
            onRatingUpdate: (start) {},
          ),
          Text(
            '$total opiniones',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget rowCal(String number, int value, double width, int total){

    return Row(
      children: [
        Text(
          number,
          style: TextStyle(
            color: Colors.black54
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          width: width,
          child: LinearProgressIndicator(
            value: value / total,
            minHeight: 8.0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.Colors.loginGradientEnd,
            ),
          ),
        ),
      ],
    );
  }

  Widget card(Resena resena){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        )
      ),
      color: Theme.Colors.loginGradientEnd,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      elevation: 7.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            header(resena.fotoPerfil, resena.username),
            comment(resena.resena),
            rating(resena.calificacion.toDouble(), resena.createdAt)
          ],
        ),
      ),
    );
  }

  Widget header(String image, String user){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(image),
                radius: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  user,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8)
                  ),
                ),
              ),
            ],
          ),
          Icon(
            FontAwesomeIcons.quoteRight,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget comment(String resena){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        resena,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8)
        ),
      ),
    );
  }

  Widget rating(double rating, String createdAt){

    String _timeago = timeAgo(createdAt);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBar(
            itemSize: 22.0,
            unratedColor: Colors.black38,
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.white,
            ),
            onRatingUpdate: (start) {},
          ),
          Text(
            _timeago,
            style: TextStyle(
            color: Colors.white.withOpacity(0.8)
            ),
          )
        ],
      ),
    );
  }
}