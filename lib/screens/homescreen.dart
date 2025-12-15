import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Data and Models
// Data and Models
import '../models/user_trip.dart';
import '../models/explore_trips.dart';
import '../data/profile_image_provider.dart';
import '../services/database_service.dart';
import '../data/app_state.dart'; // import for hasUnreadNotifications

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
    ProfileImageProvider().loadProfileImage();
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
                      
                      // Notification Icon with StreamBuilder
                      StreamBuilder<List<UserTrip>>(
                        stream: DatabaseService.getUserTrips(currentUserId),
                        builder: (context, tripSnapshot) {
                          final myTrips = tripSnapshot.data ?? [];
                          // Note: For simplicity, 'hasUnreadNotifications' logic might need
                          // to be adapted for StreamBuilder or managed via a separate Stream.
                          // For now, we will show the red dot if ANY trips exist, 
                          // or you can implement a local 'lastChecked' timestamp logic if preferred.
                          // Here we simply check if list is not empty.
                          
                          return GestureDetector(
                            onTap: () {
                              if (myTrips.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No notification available"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.notifications_active, color: Colors.blue),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: myTrips.length,
                                        separatorBuilder: (context, index) => const Divider(),
                                        itemBuilder: (context, index) {
                                          final trip = myTrips[index];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(Icons.flight_takeoff, color: Colors.orange),
                                            title: Text(
                                              trip.tripName,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              "Bound for ${trip.destination}",
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xFFE6EDED),
                                  child: Icon(Icons.notifications_outlined),
                                ),
                                if (myTrips.isNotEmpty)
                                  Positioned(
                                    right: 12,
                                    top: 12,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- Hero Image ---
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                  
                  // Replaced List with StreamBuilder
                  StreamBuilder<List<UserTrip>>(
                    stream: DatabaseService.getUserTrips(currentUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                         return const Center(child: CircularProgressIndicator());
                      }
                      final myTrips = snapshot.data ?? [];

                      if (myTrips.isEmpty) {
                        return const Text(
                          'You have no trips yet. Plan one!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: myTrips.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final trip = myTrips[index];
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
                    height: 280,
                    // Replaced List with FutureBuilder for Explore Trips
                    child: FutureBuilder<List<ExploreTrip>>(
                      future: DatabaseService.getExploreTrips(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final trips = snapshot.data ?? [];
                        
                        // Fallback if empty (e.g. before first seed completes)
                        if (trips.isEmpty) return const Center(child: Text("Loading destinations..."));

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trips.length < 3 ? trips.length : 3,
                          itemBuilder: (context, index) {
                            final trip = trips[index];

                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              child: ExploreCard(trip: trip),
                            );
                          },
                        );
                      }
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