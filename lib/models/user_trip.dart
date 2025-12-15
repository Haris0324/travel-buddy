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
  final String? tripType;

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
    this.tripType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'userId': userId,
      'tripName': tripName,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'budget': budget,
      'travelers': travelers,
      'tripType': tripType,
    };
  }

  factory UserTrip.fromMap(Map<dynamic, dynamic> map) {
    return UserTrip(
      id: map['id'] ?? '',
      tripId: map['tripId'] ?? '',
      userId: map['userId'] ?? '',
      tripName: map['tripName'] ?? '',
      destination: map['destination'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      budget: map['budget'] ?? '',
      travelers: map['travelers'] ?? '',
      tripType: map['tripType'],
    );
  }
}
