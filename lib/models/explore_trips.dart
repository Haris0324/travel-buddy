class ExploreTrip {
  final String id;
  final String name;
  final String location;
  final String imageUrl; // Asset path for the card background
  final List<String> visitingPlaces;

  const ExploreTrip({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.visitingPlaces,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'visitingPlaces': visitingPlaces,
    };
  }

  factory ExploreTrip.fromMap(Map<dynamic, dynamic> map) {
    return ExploreTrip(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      visitingPlaces: List<String>.from(map['visitingPlaces'] ?? []),
    );
  }
}