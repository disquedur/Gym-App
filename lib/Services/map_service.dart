import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class MapService {
  static const double latitude = 45.50;
  static const double longitude = -73.56;
  LatLng userPosition = const LatLng(latitude, longitude);
  File? imageFile;

  static final MapService _instance = MapService._internal();

  factory MapService() {
    return _instance;
  }

  MapService._internal();

  confirmArea(double latitude, double longitude) {
    userPosition = LatLng(latitude, longitude);
    return userPosition;
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    final pos = await Geolocator.getCurrentPosition();
    print(pos);
    return pos;
  }
}
