import 'package:url_launcher/url_launcher.dart';

class ButtonsProvider {

  static lauchMap(String $lat, String $lon) async {

    final String googleMapsUrl = "comgooglemaps://?center="+$lat+","+$lon;
    final String appleMapsUrl = "https://maps.apple.com/?q="+$lat+","+$lon;

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

}