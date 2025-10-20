import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/explore_trips_data.dart';
import '../data/user_trips_data.dart'; // FIX: Added import for userTrips
 import '../models/user_trip.dart';

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
      // Return the part of the email before the '@'
      return email.split('@').first;
    }
    return 'Guest'; // Fallback name
  }

  @override
  void initState() {
    super.initState();
    _loadMyTrips();
  }

  void _loadMyTrips() {
    setState(() {
      // Filter trips from the global list based on the current user's ID
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EDED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 45,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://wallpapers.com/images/high/dragon-ball-z-pictures-b1631prvj9jgfxi7.webp',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
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
                  Image.asset('assets/images/img_1.png'),
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
                      style: TextStyle(fontSize: 16, color: Colors.grey,),
                    )
                  else
                  ListView.builder(
                    itemCount: _myTrips.length,
                    // FIX: Added shrinkWrap and physics to prevent layout errors
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
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // limit total viewd items to 3

                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final trip = exploreTrips[index];
                        return _destinationCard(
                          imageUrl: trip.imageUrl,
                          title: trip.name,
                          location: trip.location,
                        );
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

   Widget _destinationCard({
    required String imageUrl,
    required String title,
    required String location,
  }) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16),
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.bookmark_border, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.grey, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
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
