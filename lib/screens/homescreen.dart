import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/explore_trips_data.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import '../landmark_screen.dart'; // Ensure this exists
import '../models/explore_trips.dart';
import 'dart:io';
import '../data/profile_image_provider.dart';
import 'profile_screen.dart';
import '../trip_details_page.dart'; // Ensure you have this import for the navigation

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

            // ignore: unused_local_variable
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
                  // Assuming you have this asset
                  // Image.asset('assets/images/img_1.png'),
                  // Replaced with a placeholder if asset is missing for safety:
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                        'assets/images/img_1.png',
                          fit: BoxFit.cover
                    ),
                  ),
                  const SizedBox(height: 25),

                  //  Upcoming Trips Section
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
                    // FIXED: Increased height to 300 to prevent overflow
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // Safety check for length
                      itemCount: exploreTrips.length < 3 ? exploreTrips.length : 3,
                      itemBuilder: (context, index) {
                        final trip = exploreTrips[index];
                        return _destinationCard(trip: trip);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // FIXED: Corrected the function signature and implementation
  Widget _destinationCard({required ExploreTrip trip}) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16, bottom: 10), // Added bottom margin for shadow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  trip.imageUrl,
                  height: 120, // FIXED: Reduced height slightly to fit text below
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      size: 20,
                      color: Color(0xFF6A5AE0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Text Content (The snippet you provided)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Important for layout
              children: [
                // Trip Name
                Text(
                  trip.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1, // Limit lines to prevent overflow
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        trip.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Details Button
                // Using a smaller visual footprint to avoid overflow
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size(50, 30), // Smaller touch target
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailPage(trip: trip),
                        ),
                      );
                    },
                    child: const Text("Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
