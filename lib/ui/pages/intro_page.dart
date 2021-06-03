import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController = PageController();
  double currentPage = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: Theme.Colors.myBoxDecBackG,
          child: Column(
            children: [_skip(), _body(_screenSize), _indicators(), _button()],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget _skip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false),
              child: Text(
                'Saltar',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }

  Widget _body(Size size) {
    List<String> svg = ['events.svg', 'galery.svg', 'resena.svg'];
    List<String> title = [
      'Bienvenido a Rumbero',
      'Encuentra donde bailar',
      'Conectate con gente del ambiente'
    ];

    List<String> text = [
      '',
      'Queremos brindarte opciones a la hora de escojer a donde salir o donde aprender nuevos movimientos.',
      'Forma parte de la comunidad más importante del medio en América Latina y encuentra personas que comparten la misma pasión, bailar.'
    ];

    return Container(
        height: size.height * .7,
        child: LayoutBuilder(builder: (context, contraint) {
          return PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: 3,
              itemBuilder: (BuildContext ctxt, int index) {
                return _page(svg[index], title[index], text[index], size.width);
              });
        }));
  }

  Widget _button() {
    return Container(
        margin: EdgeInsets.only(top: 25.0),
        decoration: Theme.Colors.myBoxDecButton,
        child: MaterialButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 42.0),
              child: Text(
                currentPage == 2 ? "Continuar" : "Siguiente",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
            onPressed: () {
              if (currentPage != 2)
                nextPage();
              else
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
            }));
  }

  Widget _page(String svg, String title, String text, double width) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              padding: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/svg/$svg',
                  height: 200.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _indicators() {
    List<Widget> _buildPageIndicator() {
      List<Widget> list = [];
      for (int i = 0; i < 3; i++) {
        list.add(i == currentPage ? _indicator(true) : _indicator(false));
      }
      return list;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildPageIndicator(),
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 20 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: isActive ? BoxShape.rectangle : BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
