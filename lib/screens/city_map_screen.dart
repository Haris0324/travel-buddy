import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/city.dart';

class CityMapScreen extends StatefulWidget {
  final City city;

  const CityMapScreen({super.key, required this.city});

  @override
  State<CityMapScreen> createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    // Add marker for the city center
    _markers.add(
      Marker(
        markerId: MarkerId(widget.city.name),
        position: widget.city.coordinates,
        infoWindow: InfoWindow(
          title: widget.city.name,
          snippet: widget.city.description,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );

    // Add markers for landmarks
    for (var landmark in widget.city.landmarks) {
      _markers.add(
        Marker(
          markerId: MarkerId(landmark.name),
          position: landmark.location,
          infoWindow: InfoWindow(title: landmark.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.city.coordinates,
          zoom: 12.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
