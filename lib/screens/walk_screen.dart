import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test/widgets/walk_map.dart';

class WalkScreen extends StatefulWidget {
  @override
  _WalkScreenState createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  List<LatLng> _route = [];
  List<WalkEvent> _events = [];
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startTrackingLocation();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    }
    super.dispose();
  }

  void _startTrackingLocation() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10, // meters
    ).listen((Position position) {
      setState(() {
        _route.add(LatLng(position.latitude, position.longitude));
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _route.add(LatLng(position.latitude, position.longitude));
    });
  }

  void _addEvent(WalkEventType type) {
    setState(() {
      _events.add(WalkEvent(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        position: _route.last,
        type: type,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('散歩のルート')),
      body: WalkMap(route: _route, events: _events),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _addEvent(WalkEventType.poo),
            tooltip: 'うんちを記録',
            child: Icon(Icons.add_location),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _addEvent(WalkEventType.encounter),
            tooltip: '出会いを記録',
            child: Icon(Icons.pets),
          ),
        ],
      ),
    );
  }
}
