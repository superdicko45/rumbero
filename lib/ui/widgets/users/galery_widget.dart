import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/blocs/user/galery_bloc.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';
import 'package:rumbero/ui/widgets/galery_widget.dart';
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class GaleryPage extends StatefulWidget {

  final int userId;
  final List<Galeria> galeria;
  final bool uploadImg;
  final GlobalKey<ScaffoldState> scaffoldstate;

  GaleryPage({
    @required this.userId, 
    @required this.galeria,
    this.uploadImg,
    this.scaffoldstate
  });

  @override
  _GaleryPageState createState() => _GaleryPageState();
}

class _GaleryPageState extends State<GaleryPage>  with AutomaticKeepAliveClientMixin{

  final GaleryBloc _galeryBloc = new GaleryBloc();

  @override
  void initState() {
    super.initState();
    _galeryBloc.initLoad(widget.galeria, widget.userId, widget.uploadImg);
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
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if(
              !snapshot.data &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              scrollInfo is ScrollEndNotification
            )
              _galeryBloc.loadMore(widget.userId);

            return true;
          },
          child: _body()
        );
      }
    );
  }

  Future<void> loadAssets() async {

    try {
      List<Asset> _resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
      );

      var _snackBar = SnackBar(
        content: Text('Subiendo galería...')
      );

      widget.scaffoldstate.currentState.showSnackBar(_snackBar);

      await _galeryBloc.uploadGalery(widget.userId, _resultList);

    } on Exception catch (e) {
      e.toString();
    }

    if (!mounted) return;
  }

  Widget _body() {
    return Column(
      children: [
        _canUpload(),
        Expanded(
          child: StreamBuilder<List<Galeria>>(
            stream: _galeryBloc.galeriaController.stream,
            builder: (context, AsyncSnapshot<List<Galeria>> snapshot) {
              
              if(snapshot.hasData && snapshot.data.length > 0) 
                  return GaleryWidget(galeria: snapshot.data);
              else 
                return NoInfo(svg: 'galery.svg', text: 'No pudimos encontrar galería de este usuario.');
            }
          ),
        ),
      ],
    );
  }

  Widget _canUpload(){
    return StreamBuilder<bool>(
      stream: _galeryBloc.canUploadController.stream,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data ? _buttonAddGalery() : SizedBox();
      }
    );
  }

  Widget _buttonAddGalery() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _galeryBloc.isUploadingController.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FloatingActionButton.extended(
            label: snapshot.data
              ? CircularProgressIndicator()
              : Text('Agregar galería', style: TextStyle(color: Theme.Colors.loginGradientEnd),),
            key: null,
            backgroundColor: Theme.Colors.loginGradientStart,
            icon: snapshot.data
              ? null
              : Icon(Icons.add_photo_alternate, color: Theme.Colors.loginGradientEnd,),
            onPressed: () => snapshot.data ? null : loadAssets()
          ),
        );
      }
    );
  }
}