import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatelessWidget {

  final double lat, lon, alto;
  
  const Map({@required this.lat, @required this.lon, @required this.alto, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Set<Marker> _markers = Set();
    Completer<GoogleMapController> _controller = Completer();


    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }

    _markers.add(
      Marker(
        markerId: MarkerId(UniqueKey().toString()),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: 'Social', snippet: 'Aqui bailaras')
      ),
    );

    return Container(
      height: alto,
      width: double.infinity,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lon),
          zoom: 15.4746,
        ),
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        markers: _markers,
      ),
    );
  }
}