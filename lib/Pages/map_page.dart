import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final LatLng currentLocation = LatLng(45.50, -73.56);

  List<LatLng> polylineCoordinates = [];
  Marker? origin;
  Marker? destination;

  addMarker(LatLng pos) {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
            markerId: MarkerId("source"),
            infoWindow: InfoWindow(title: "Origin"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: pos);
        destination = null;
      });
    } else {
      setState(() {
        destination = Marker(
            markerId: MarkerId("destination"),
            infoWindow: InfoWindow(title: "Destination"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(target: currentLocation),
          polylines: {
            Polyline(
                polylineId: PolylineId("route"),
                points: polylineCoordinates,
                color: Color.fromARGB(255, 105, 148, 183),
                width: 6)
          },
          onLongPress: addMarker,
          markers: {
            if (origin != null) origin!,
            if (destination != null) destination!,
          }),
    );
  }
}
