import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Extract username from email
  Future<String?> userName() async {
    final String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      return email.split('@').first;
    }
    return 'Guest';
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

                  // --- Headline Text ---
                 Image.asset('assets/images/img_1.png'),

                  // --- Section Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Best Destination',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- Destination Cards (Horizontal Scroll) ---
                  SizedBox(
                    height: 270,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _destinationCard(
                          imageUrl:
                          'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/31/49/e5/4a/caption.jpg?w=1000&h=-1&s=1',
                          title: 'Niladri Reservoir',
                          location: 'Tekergat, Sunamgnj',
                         ),
                        _destinationCard(
                          imageUrl:
                          'https://i.pinimg.com/1200x/0d/8e/5a/0d8e5ae314cfd1420857f9872cbac45f.jpg',
                          title: 'Darmas Hills',
                          location: 'Bali, Indonesia',
                         ),
                        _destinationCard(
                          imageUrl:
                          'https://i.pinimg.com/736x/fa/96/92/fa96921bb6abd253ddc114d4ef1d9ea3.jpg',
                          title: 'Desert Mirage',
                          location: 'Doha, Qatar',
                         ),
                      ],
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
          // --- Image Section ---
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

          // --- Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ),

          // --- Location ---
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
