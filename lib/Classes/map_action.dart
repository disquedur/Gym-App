import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAction extends StatefulWidget {
  @override
  _MapActionState createState() => _MapActionState();
}

class _MapActionState extends State<MapAction>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  int isSelect = 0;
  Marker? origin;
  Marker? destination;
  LatLng currentLocation = LatLng(45.50, -73.56);

  late AnimationController animationController;
  late Animation<Color?> buttonColor;
  late Animation<Offset> translateButton;

  @override
  initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    buttonColor = ColorTween(
      begin: Colors.blue[100],
      end: Colors.indigo[900],
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.00,
        1.00,
      ),
    ));
    translateButton = Tween<Offset>(
      begin: Offset(-50, 0.0),
      end: Offset(10, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.0,
        0.75,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Transform addMarker() {
    return Transform(
        transform: Matrix4.translationValues(
          translateButton.value.dx * 1,
          0,
          0.0,
        ),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add_location_alt),
        ));
  }

  Transform deleteMarker() {
    return Transform(
      transform: Matrix4.translationValues(
        translateButton.value.dx * 2,
        0,
        0.0,
      ),
      child: FloatingActionButton(
          onPressed: () {
            print("hello");
          },
          child: Icon(
            Icons.location_off_rounded,
          )),
    );
  }

  Transform getCurrentLocation() {
    return Transform(
        transform: Matrix4.translationValues(
          translateButton.value.dx * 3,
          0,
          0.0,
        ),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.my_location),
        ));
  }

  FloatingActionButton toggle() {
    return FloatingActionButton(
      backgroundColor: buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: Icon(
        Icons.edit_location_alt,
        color: isOpened && isSelect == 0 ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        toggle(),
        if (isOpened)
          Row(
            children: [
              addMarker(),
              deleteMarker(),
              getCurrentLocation(),
            ],
          )
      ],
    );
  }
}
