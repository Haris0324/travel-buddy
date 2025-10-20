import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import 'add_trip.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  // In a real app, this would come from your auth provider.
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

  // --- Helper function to get a color based on the index ---
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
      appBar: AppBar(title: Text('My Trips')),
      body: _myTrips.isEmpty
          ? Center(
        child: Text(
          'You have no trips yet. Plan one!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _myTrips.length,
        itemBuilder: (context, index) {
          final trip = _myTrips[index];
          final cardColor = _getCardColor(index); // Get a unique color

          return Card(
            // 1. Colorful Theme for Card
            color: cardColor.withOpacity(0.9), // Use the determined color
            elevation: 6, // Slightly higher elevation for a lift effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Better margin

            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding inside the card
              child: ListTile(
                // 2. Text Styling for Contrast
                title: Text(
                  trip.tripName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900, // Very bold
                    fontSize: 20,
                    color: Colors.white, // White text for contrast on color background
                  ),
                ),
                subtitle: Text(
                  '${trip.destination} (${trip.startDate} - ${trip.endDate})',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85), // Slightly transparent white
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3), // Subtle background for the traveler count
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