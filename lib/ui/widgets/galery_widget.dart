import 'package:flutter/material.dart';

import 'package:rumbero/logic/entity/models/galeria_model.dart';

import 'package:rumbero/ui/pages/image_page.dart';

class GaleryWidget extends StatelessWidget {
  final List<Galeria> galeria;

  const GaleryWidget({Key key, this.galeria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(galeria.length, (index) {
        return image(galeria[index], context, index);
      }),
    );
  }

  Widget image(Galeria imagen, context, int index) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImagePage(
                      galeria: galeria,
                      index: index,
                    ))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: FadeInImage(
            image: NetworkImage(imagen.archivoFoto),
            placeholder: AssetImage('assets/img/tempo.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
