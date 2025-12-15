import 'package:google_maps_flutter/google_maps_flutter.dart';

class Landmark {
  final String name;
  final LatLng location;

  Landmark({required this.name, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }

  factory Landmark.fromMap(Map<dynamic, dynamic> map) {
    return Landmark(
      name: map['name'] ?? '',
      location: LatLng(
        (map['latitude'] as num?)?.toDouble() ?? 0.0,
        (map['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'landmarks': landmarks.map((l) => l.toMap()).toList(),
    };
  }

  factory City.fromMap(Map<dynamic, dynamic> map) {
    return City(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      coordinates: LatLng(
        (map['latitude'] as num?)?.toDouble() ?? 0.0,
        (map['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      landmarks: (map['landmarks'] as List<dynamic>?)
              ?.map((l) => Landmark.fromMap(l))
              .toList() ??
          [],
    );
  }
}
