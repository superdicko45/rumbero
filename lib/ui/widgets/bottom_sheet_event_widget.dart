import 'package:flutter/material.dart';

import 'package:rumbero/logic/blocs/event/bottom_sheet_bloc.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/ui/widgets/noInfo_widget.dart';

class BottomSheetEvent extends StatefulWidget {
  final String eventId;
  BottomSheetEvent({@required this.eventId, Key key}) : super(key: key);

  @override
  _BottomSheetEventState createState() => _BottomSheetEventState();
}

class _BottomSheetEventState extends State<BottomSheetEvent> {
  BottomSheetBloc _bottomSheetBloc = new BottomSheetBloc();

  @override
  void initState() {
    super.initState();
    _bottomSheetBloc.initoad(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<stateType>(
      stream: _bottomSheetBloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.data) {
          case stateType.LOADING:
            return loading();
            break;
          case stateType.UNSIGNIN:
            return _empty(context);
            break;
          case stateType.UNCHECKIN:
            return _buttons(context, stateType.UNCHECKIN);
            break;
          case stateType.SUCCESS:
            return _buttons(context, stateType.SUCCESS);
            break;
          default:
            return loading();
        }
      },
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buttons(BuildContext context, stateType type) {
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(
          child: NoInfo(
        svg: 'party.svg',
        text: '',
      )),
      type == stateType.SUCCESS
          ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'En horabuena ya tienes tu ticket!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ticketButton(context)
                ],
              ),
            )
          : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Generar el ticket garantizará entrada al evento!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  eventButton(context)
                ],
              ),
            )
    ];

    return _orientation != Orientation.landscape
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _items,
          )
        : Row(
            children: _items,
          );
  }

  Widget _empty(BuildContext context) {
    final _orientation = MediaQuery.of(context).orientation;

    final List<Widget> _items = [
      Expanded(
          child: NoInfo(
        svg: 'signin.svg',
        text: '',
      )),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Inicia sesión para generar tu entrada!.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
            floatinButton(context)
          ],
        ),
      )
    ];

    return _orientation != Orientation.landscape
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _items,
          )
        : Row(
            children: _items,
          );
  }

  Widget eventButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(
        Icons.qr_code_rounded,
        color: Colors.white,
      ),
      label: Text(
        'Generar ticket',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => _bottomSheetBloc.getTicket(widget.eventId),
    );
  }

  Widget ticketButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(
        Icons.qr_code_rounded,
        color: Colors.white,
      ),
      label: Text(
        'Ver ticket',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        final List<String> _params = [
          "4",
          "14",
        ];

        Navigator.pushNamed(context, '/ticket', arguments: _params);
      },
    );
  }

  Widget floatinButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.Colors.loginGradientStart,
      icon: Icon(
        Icons.input,
        color: Colors.white,
      ),
      label: Text(
        'Iniciar sesión',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => Navigator.pushNamed(context, '/login'),
    );
  }
}
