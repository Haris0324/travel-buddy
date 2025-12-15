import 'package:google_maps_flutter/google_maps_flutter.dart';

class Landmark {
  final String name;
  final LatLng location;

  Landmark({required this.name, required this.location});
}

class City {
  final String name;
  final String description;
  final String imageUrl;
  final LatLng coordinates;
  final List<Landmark> landmarks;

  City({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coordinates,
    required this.landmarks,
  });
}
