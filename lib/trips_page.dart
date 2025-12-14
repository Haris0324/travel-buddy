import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import 'add_trip.dart';
import 'user_trip_detail_page.dart'; // <--- 1. ADD THIS IMPORT

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String get currentUserId => user.uid;
  List<UserTrip> _myTrips = [];

  @override
  void initState() {
    super.initState();
    _loadMyTrips();
  }

  void _loadMyTrips() {
    setState(() {
      _myTrips = userTrips
          .where((trip) => trip.userId == currentUserId)
          .toList();
    });
  }

  Color _getCardColor(int index) {
    const colors = [
      Colors.lightBlueAccent,
      Colors.teal,
      Colors.deepOrangeAccent,
      Colors.purpleAccent,
      Colors.green,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: _myTrips.isEmpty
          ? const Center(
        child: Text(
          'You have no trips yet. Plan one!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _myTrips.length,
        itemBuilder: (context, index) {
          final trip = _myTrips[index];
          final cardColor = _getCardColor(index);

          return Card(
            color: cardColor.withOpacity(0.9),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                // --- 2. ADD NAVIGATION HERE ---
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserTripDetailPage(trip: trip),
                    ),
                  );
                },
                // -------------------------------
                title: Text(
                  trip.tripName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  '${trip.destination} (${trip.startDate} - ${trip.endDate})',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Travelers:  ${trip.travelers} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}