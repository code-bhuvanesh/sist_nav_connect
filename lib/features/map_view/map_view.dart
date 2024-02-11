import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final LatLng initialPostion;
  final LatLng? currentLocation;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final bool showCurrentLocation;
  final MapController mapController;
  final void Function(TapPosition, LatLng)? onMapTap;
  const MapView({
    super.key,
    this.initialPostion = const LatLng(13.0827, 80.2707),
    this.showCurrentLocation = false,
    this.markers = const [],
    this.polylines = const [],
    this.currentLocation,
    this.onMapTap,
    required this.mapController,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  var distancecal = const Distance(roundResult: true);
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: const LatLng(13.0827, 80.2707),
        initialZoom: 9.2,
        onTap: widget.onMapTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        PolylineLayer(polylines: widget.polylines),
        MarkerLayer(
          rotate: true,
          // markers: [
          //   // if (currentLocation != null)
          //   //   Marker(
          //   //     rotate: true,
          //   //     point: centerLatLng,
          //   //     child: const Icon(
          //   //       Icons.pin_drop,
          //   //       size: 50,
          //   //     ),
          //   //   )

          // ],
          markers: widget.markers,
        ),
        // if (widget.showCurrentLocation)
        CircleLayer(circles: [
          if (widget.currentLocation != null)
            CircleMarker(
              point: widget.currentLocation!,
              radius: 10,
              borderColor: Colors.blue,
              color: const Color.fromARGB(150, 156, 214, 255),
              borderStrokeWidth: 3,
            )
        ])
      ],
    );
  }
}
