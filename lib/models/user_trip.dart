class UserTrip {
  final String id;
  final String userId;
  final String tripName;
  final String tripId;
  final String destination;
  final String startDate;
  final String endDate;
  final String budget;
  final String travelers;

  UserTrip({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.travelers,
    String? tripType,
  });
}
