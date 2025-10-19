import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import 'add_trip.dart';

class TripsPage extends StatefulWidget {
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
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      trip.tripName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${trip.destination} (${trip.startDate} - ${trip.endDate})',
                    ),
                    trailing: Text('${trip.travelers} travelers'),
                  ),
                );
              },
            ),
    );
  }
}
