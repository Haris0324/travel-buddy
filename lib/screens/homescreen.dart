import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Extract username from email (returns Future<String?>)
  Future<String?> userName() async {
    final String? email = FirebaseAuth.instance.currentUser?.email;

    if (email != null) {
      String username = email.split('@').first;
      print(username);
      return username;
    } else {
      print('No user is signed in');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: userName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final username = snapshot.data ?? 'Guest';

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xE6E6EDED),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                         height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://wallpapers.com/images/high/dragon-ball-z-pictures-b1631prvj9jgfxi7.webp',
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "$username  ",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xE6E6EDED),
                        child: Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
