import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rumbero/logic/entity/models/galeria_model.dart';

class ImagePage extends StatefulWidget {
  final List<Galeria> galeria;
  final int index;

  const ImagePage({Key key, this.galeria, this.index}) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return PhotoViewGallery(
      pageOptions: widget.galeria
          .map<PhotoViewGalleryPageOptions>((Galeria g) =>
              PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(g.archivoFoto),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.8))
          .toList(),
      enableRotation: true,
      scrollDirection: Axis.vertical,
      pageController: _pageController,
    );
  }
}
