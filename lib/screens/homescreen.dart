import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Data and Models
import '../data/explore_trips_data.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import '../models/explore_trips.dart';
import '../data/profile_image_provider.dart';

// Screens
import 'profile_screen.dart';
import '../trip_details_page.dart';
import 'package:travel_buddy/explore_page.dart'; // Make sure ExploreCard is a public class in this file!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String get currentUserId => user.uid;

  List<UserTrip> _myTrips = [];

  // Extract username from email
  Future<String?> userName() async {
    final String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return email.split('@').first;
    }
    return 'Guest';
  }

  @override
  void initState() {
    super.initState();
    _loadMyTrips();
    ProfileImageProvider().loadProfileImage();
  }

  void _loadMyTrips() {
    setState(() {
      _myTrips =
          userTrips.where((trip) => trip.userId == currentUserId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: userName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final username = snapshot.data ?? 'Guest';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Top Bar ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Section
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
                          ).then((_) {
                            setState(() {}); // Refresh state
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EDED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 45,
                          child: Row(
                            children: [
                              // Profile Picture
                              ValueListenableBuilder<String?>(
                                  valueListenable:
                                  ProfileImageProvider().imagePath,
                                  builder: (context, path, _) {
                                    return CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage: path != null
                                          ? FileImage(File(path))
                                          : null,
                                      child: path == null
                                          ? const Icon(Icons.person,
                                          color: Colors.white, size: 20)
                                          : null,
                                    );
                                  }),
                              const SizedBox(width: 8),

                              // Username
                              StreamBuilder<User?>(
                                stream: FirebaseAuth.instance.userChanges(),
                                builder: (context, snapshot) {
                                  final user = snapshot.data;
                                  final displayName = (user?.displayName !=
                                      null &&
                                      user!.displayName!.isNotEmpty)
                                      ? user.displayName!
                                      : (user?.email != null
                                      ? user!.email!.split('@').first
                                      : 'Guest');

                                  return Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFE6EDED),
                        child: Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- Hero Image ---
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                        'assets/images/img.png',
                        width: 100,
                        fit: BoxFit.contain
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Upcoming Trips Section ---
                  const Text(
                    'Upcoming Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_myTrips.isEmpty)
                    const Text(
                      'You have no trips yet. Plan one!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: _myTrips.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final trip = _myTrips[index];
                        final cardColor = Colors.black87;

                        return Card(
                          color: cardColor.withOpacity(0.9),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(trip.tripName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Colors.white)),
                              subtitle: Text(
                                  '${trip.destination} (${trip.startDate} - ${trip.endDate})',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w500)),
                              trailing: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text('Travelers: ${trip.travelers}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 25),

                  // --- Best Destination Section (Horizontal List) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Best Destination',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 280, // Height of the horizontal scroll area
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: exploreTrips.length < 3 ? exploreTrips.length : 3,
                      itemBuilder: (context, index) {
                        final trip = exploreTrips[index];

                        // FIX: Wrap ExploreCard in a Container with WIDTH
                        return Container(
                          width: 200, // Important: Gives the card a fixed width
                          margin: const EdgeInsets.only(right: 12),
                          child: ExploreCard(trip: trip),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}