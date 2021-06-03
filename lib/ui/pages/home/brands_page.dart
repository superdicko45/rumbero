import 'package:flutter/material.dart';
import 'package:rumbero/logic/blocs/home/marcas_bloc.dart';
import 'package:rumbero/logic/entity/models/marca_model.dart';
import 'package:rumbero/logic/entity/responses/marcas_response.dart';
import 'package:rumbero/ui/pages/articles_page.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

//import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({Key key}) : super(key: key);

  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage>
    with AutomaticKeepAliveClientMixin {
  MarcasBloc marcasBloc = new MarcasBloc();

  @override
  void initState() {
    super.initState();
    marcasBloc.getMarcas();
  }

  @override
  void dispose() {
    super.dispose();
    marcasBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body(context);
  }

  @override
  bool get wantKeepAlive => true;

  Widget _body(context) {
    return RefreshIndicator(
      onRefresh: marcasBloc.getMarcas,
      child: StreamBuilder<MarcasResponse>(
        stream: marcasBloc.mainSubject.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? _main(snapshot.data) : _loader();
        },
      ),
    );
  }

  Widget _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _main(MarcasResponse marcasResponse) {
    return !marcasResponse.error
        ? ListView(
            children: <Widget>[
              _header('Las mejores marcas para ti'),
              _filter(marcasResponse.tags),
              SizedBox(
                height: 30,
              ),
              _brandsLayout(),
              SizedBox(
                height: 10,
              )
            ],
          )
        : _empty();
  }

  Widget _empty() {
    return Center(
      child: NoInfo(
        svg: 'events.svg',
        text: 'Sin coincidencias',
      ),
    );
  }

  Widget _filter(List<Tags> tags) {
    tags.insert(0, new Tags(id: 0, categoria: 'Todos'));

    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<int>(
                  stream: marcasBloc.selectedSubject.stream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    int selected = snapshot.data;
                    return ChoiceChip(
                        label: Text(tags[index].categoria),
                        labelStyle: index == selected
                            ? TextStyle(color: Colors.white)
                            : null,
                        selectedColor: Theme.Colors.loginGradientStart,
                        backgroundColor: Colors.white10,
                        selected: index == selected ? true : false,
                        onSelected: (bool value) =>
                            marcasBloc.filter(tags[index].id));
                  }));
        },
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: new TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 19.0,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }

  Widget _brandsLayout() {
    return StreamBuilder<List<Marca>>(
        stream: marcasBloc.marcasSubject.stream,
        builder: (context, snapshot) {
          List<Marca> marcas = snapshot.data;
          return marcas != null && marcas.isNotEmpty
              ? Wrap(
                  children: List.generate(
                      marcas.length, (index) => _brand(marcas[index])),
                )
              : SizedBox();
        });
  }

  Widget _brand(Marca marca) {
    String tagId = UniqueKey().toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticlesPage(
                    marca: marca,
                    tagId: tagId,
                  )),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 2,
        height: (MediaQuery.of(context).size.height) / 5,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)),
          child: Hero(
            tag: tagId,
            child: FadeInImage(
              image: NetworkImage(marca.imagen),
              placeholder: AssetImage('assets/img/tempo.gif'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
