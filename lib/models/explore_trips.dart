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
}