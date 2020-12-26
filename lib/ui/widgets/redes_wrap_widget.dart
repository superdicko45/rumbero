import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;
import 'package:rumbero/logic/entity/models/redes_model.dart';

class RedesWrap extends StatelessWidget {

  final List<Redes> redes;
  final bool showText;

  const RedesWrap({
    @required this.redes,
    this.showText = true,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<Widget> items = List<Widget>();

    redes.forEach((element) => items.add(redIcon(element)) );

    return Wrap(
      alignment: WrapAlignment.center,
      children: items,
    );
  }

  Widget redIcon(Redes red){

    
    Map<String, IconData> iconMapping = {
      'Facebook'  : FontAwesomeIcons.facebook,
      'Twitter'   : FontAwesomeIcons.twitter,
      'Instagram' : FontAwesomeIcons.instagram,
      'Email'     : FontAwesomeIcons.mailBulk,
      'Whatsapp'  : FontAwesomeIcons.whatsapp,
      'Website'   : FontAwesomeIcons.internetExplorer,
      'Youtube'   : FontAwesomeIcons.youtube,
      'Snapchat'   : FontAwesomeIcons.snapchat
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => _launchSocial(red.fullUrl + red.url),
            child: Icon(iconMapping[red.redSocial], 
              color: Theme.Colors.loginGradientEnd,
            ),
            backgroundColor: Theme.Colors.loginGradientStart,
          ),
          showText 
            ? Text(
                red.url,
                style: TextStyle(
                  color: Colors.black54
                )
              )
            : SizedBox() ,
        ],
      ),
    );
  }

  void _launchSocial(String url) async {
    
    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }
}