import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/Classes/map_action.dart';
import 'package:my_app/Services/map_service.dart';

import '../Classes/profile.dart';

class MapComponent extends StatefulWidget {
  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  LatLng currentLocation = LatLng(45.50, -73.56);

  //CameraPosition cameraPosition = CameraPosition(target: LatLng(45.50, -73.56));
  MapService map = MapService();

  //final BitmapDescriptor customIcon = BitmapDescriptor.fromAsset('assets/marker_icon.png');
  Completer<GoogleMapController> controller = Completer();
  double xPosition = 0;
  double yPosition = 0;
  Marker? origin;
  Marker? destination;

  @override
  initState() {
    map.getUserCurrentLocation();
    super.initState();
  }

  addMarker(LatLng pos) {
    setState(() {
      if (origin == null) {
        origin = Marker(
            markerId: MarkerId("source"),
            infoWindow: InfoWindow(
              title: "Info",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Profile(
                      mapService: map,
                    );
                  },
                );
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: pos);
        destination = null;
      } else {
        origin = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: currentLocation),
                polylines: {
                  const Polyline(
                      polylineId: PolylineId("route"),
                      color: Color.fromARGB(255, 105, 148, 183),
                      width: 6)
                },
                onLongPress: addMarker,
                markers: {
                  if (origin != null) origin!,
                  if (destination != null) destination!,
                },
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: true,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.03,
                child: MapAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
