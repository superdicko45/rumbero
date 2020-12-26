import 'package:flutter/material.dart';

import 'package:rumbero/logic/blocs/academy/galery_bloc.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/ui/widgets/galery_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class GaleryPage extends StatefulWidget {

  final int academyId;
  final List<Galeria> galeria;

  GaleryPage({Key key, @required this.academyId, this.galeria}) : super(key: key);

  @override
  _GaleryPageState createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage>  with AutomaticKeepAliveClientMixin{

  final GaleryBloc _galeryBloc = new GaleryBloc();

  @override
  void initState() {
    super.initState();
    _galeryBloc.initLoad(widget.galeria);
    _galeryBloc.isLoadingController;
    _galeryBloc.galeriaController;
  }

  @override
  void dispose() {
    super.dispose();
    _galeryBloc.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<bool>(
      stream: _galeryBloc.isLoadingController.stream,
      initialData: false,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if(
                    !snapshot.data &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    scrollInfo is ScrollEndNotification
                  )
                    _galeryBloc.loadMore(widget.academyId);

                  return true;
                },
                child: _body()
              )  
            )
          ],
        );
      }
    );
  }

  Widget _body() {
    return StreamBuilder<List<Galeria>>(
      stream: _galeryBloc.galeriaController.stream,
      builder: (context, AsyncSnapshot<List<Galeria>> snapshot) {
        
        if(snapshot.hasData && snapshot.data.length > 0) 
            return GaleryWidget(galeria: snapshot.data);
        else 
          return NoInfo(svg: 'galery.svg', text: 'No pudimos encontrar galería de esta academia.');
      }
    );
  }
}