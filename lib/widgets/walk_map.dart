import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkMap extends StatefulWidget {
  final List<LatLng> route;
  final List<WalkEvent> events;

  WalkMap({required this.route, required this.events});

  @override
  _WalkMapState createState() => _WalkMapState();
}

class _WalkMapState extends State<WalkMap> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> _buildMarkers() {
    return widget.events
        .map((event) => Marker(
      markerId: MarkerId(event.id),
      position: event.position,
      icon: event.type == WalkEventType.poo
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: event.type.description),
    ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.route.first,
        zoom: 15,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          points: widget.route,
          color: Colors.blue,
          width: 4,
        ),
      },
      markers: _buildMarkers(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}

enum WalkEventType { poo, encounter }

extension WalkEventTypeDescription on WalkEventType {
  String get description {
    switch (this) {
      case WalkEventType.poo:
        return 'うんち';
      case WalkEventType.encounter:
        return '出会い';
    }
  }
}

class WalkEvent {
  final String id;
  final LatLng position;
  final WalkEventType type;

  WalkEvent({required this.id, required this.position, required this.type});
}

