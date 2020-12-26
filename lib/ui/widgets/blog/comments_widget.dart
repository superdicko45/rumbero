import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:rumbero/utils/timeformat.dart';
import 'package:rumbero/logic/repository/login_repository.dart';

import 'package:rumbero/logic/blocs/bloc/comments_bloc.dart';
import 'package:rumbero/logic/entity/models/comentario_model.dart';
import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class CommentsPage extends StatefulWidget {

  final int blogId;
  CommentsPage({Key key, @required this.blogId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with AutomaticKeepAliveClientMixin{

  final CommentBloc _commentBloc = new CommentBloc();
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentBloc.getComments(widget.blogId.toString());
    _commentBloc.commentController;
    _commentBloc.stateTypeController;
  }

  @override
  void dispose() {
    super.dispose();
    _commentBloc.dispose();
    myController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLogin = Provider.of<LoginRepository>(context).isLogin();

    return StreamBuilder<bool>(
      stream: _commentBloc.isLoadingController.stream,
      initialData: false,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            _addCommentWidget(isLogin),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if(
                    !snapshot.data &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.axisDirection == AxisDirection.down
                  )
                    _commentBloc.loadMore(widget.blogId.toString());

                  return true;
                },
                child: _body()
              )  
            ),
            Container(
              height: snapshot.data ? 50.0 : 0,
              child: _loader()
            ),
          ],
        );
      }
    );
  }

  void _save() async{

    bool response = await _commentBloc.addComment(widget.blogId.toString());

    if(response) myController.clear();
  }

  Widget _addCommentWidget(bool isLogin){

    if(isLogin)
      return Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 5.0),
                  child: _textField(),
                )
              ),
              _saveButton()
            ],
          ),
        ),
      );
    else 
      return _noSignIn();  
  }

  Widget _noSignIn() {
    return Padding(
      padding: EdgeInsets.only(top:8.0, left: 18.0, right: 18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Inicia sesión para comentar', style: TextStyle(color: Colors.black54)),
              ),
              FloatingActionButton.extended(
                backgroundColor: Theme.Colors.loginGradientEnd,
                onPressed: () => Navigator.of(context).pushNamed('/login'), 
                label: Text('Entrar'),
                icon: Icon(Icons.input),
              ),
            ],
          ),
          Divider(color: Theme.Colors.loginGradientEnd,)
        ],
      ),
    );
  }

  Widget _saveButton() {

    return StreamBuilder<stateSignIn>(
      stream: _commentBloc.stateTypeController.stream,
      initialData: stateSignIn.WAITING,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        if(snapshot.data == stateSignIn.WAITING) {
          return FloatingActionButton.extended(
            backgroundColor: Theme.Colors.loginGradientStart.withOpacity(0.5),
            icon: Icon(Icons.send,),
            label: Text('Enviar'),
            onPressed: null
          );
        }

        else if(snapshot.data == stateSignIn.ENABLE) {
          return FloatingActionButton.extended(
            backgroundColor: Theme.Colors.loginGradientStart,
            icon: Icon(Icons.send, color: Theme.Colors.loginGradientEnd,),
            label: Text('Enviar', style: TextStyle(color: Theme.Colors.loginGradientEnd),),
            onPressed: () => _save()
          );
        }

        else if(snapshot.data == stateSignIn.LOADING) {
          return FloatingActionButton(
            backgroundColor: Theme.Colors.loginGradientStart,
            child: CircularProgressIndicator(backgroundColor: Colors.white10,),
            onPressed: (){}
          );
        }

        else {
          return Center(
            child: Text('no estas logeado')
          );
        }
      },
    );
  }

  Widget _textField(){
    return TextFormField(
      controller: myController,
      onChanged: (String input) => _commentBloc.tipyng(input),
      minLines: 1,
      maxLines: 5,
      maxLength: 100,
      cursorColor: Colors.white,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
        hintText: 'Escribe un comentario...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 0, 
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: Theme.Colors.loginGradientStart.withOpacity(0.1),
      )
    );
  }

  Widget _empty() {
    
    return NoInfo(svg: 'events.svg', text: 'Sin comentarios aun.',);
  }

  Widget _body() {
    return StreamBuilder<List<Comentario>>(
      stream: _commentBloc.commentController.stream,
      builder: (context, AsyncSnapshot<List<Comentario>> snapshot) {
        
        if (snapshot.hasData){

          List<Comentario> _comentarios = snapshot.data;

          if(_comentarios.length > 0)
            return ListView.builder(
              itemCount: _comentarios.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _card(_comentarios[index]);
              }
            );

          else
            return _empty();
        }
        
        else return _loader();
      }
    );
  }

  Widget _loader(){
    return Center(
      child: CircularProgressIndicator(),
    );  
  }

  Widget _card(Comentario comentario){
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
            header(comentario.fotoPerfil, comentario.username),
            comment(comentario.comentario),
            created(comentario.createdAt)
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

  Widget created(String createdAt){

    String _timeago = timeAgo(createdAt);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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