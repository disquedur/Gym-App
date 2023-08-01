import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  GoogleMapController? _controller;
  final LatLng _initialCameraPosition = LatLng(37.422, -122.084);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialCameraPosition),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            print(_controller);
          });
        },
      ),
    );
  }
}
