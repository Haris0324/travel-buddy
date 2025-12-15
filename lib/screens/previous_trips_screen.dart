import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';

class PreviousTripsScreen extends StatefulWidget {
  const PreviousTripsScreen({super.key});

  @override
  State<PreviousTripsScreen> createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<UserTrip> _myTrips = [];

  @override
  void initState() {
    super.initState();
    _loadMyTrips();
  }

  void _loadMyTrips() {
    setState(() {
      _myTrips = userTrips.where((trip) => trip.userId == user.uid).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Previous Trips', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _myTrips.isEmpty
          ? const Center(
              child: Text('No previous trips found.', style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              itemCount: _myTrips.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final trip = _myTrips[index];
                return Card(
                  color: Colors.black87.withOpacity(0.9),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      title: Text(trip.tripName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.white)),
                      subtitle: Text(
                          '${trip.destination}\n${trip.startDate} - ${trip.endDate}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500)),
                      isThreeLine: true,
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('${trip.travelers} Travelers',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
