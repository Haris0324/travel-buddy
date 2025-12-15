import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_trip.dart';
import '../services/database_service.dart';

class PreviousTripsScreen extends StatefulWidget {
  const PreviousTripsScreen({super.key});

  @override
  State<PreviousTripsScreen> createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen> {
  final user = FirebaseAuth.instance.currentUser!;

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
      body: StreamBuilder<List<UserTrip>>(
        stream: DatabaseService.getUserTrips(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTrips = snapshot.data ?? [];
          // Filter logic if "Previous" means past date? 
          // The original code just showed ALL trips for the user. 
          // I will keep it showing all trips, or filter by date if requested.
          // The prompt didn't specify logic change, so I'll show all trips consistent with previous behavior.
          
          if (allTrips.isEmpty) {
            return const Center(
              child: Text('No previous trips found.', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: allTrips.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final trip = allTrips[index];
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
          );
        }
      ),
    );
  }
}
