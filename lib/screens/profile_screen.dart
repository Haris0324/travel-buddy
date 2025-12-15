import 'dart:io';
import '../data/profile_image_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/screens/bookmarked_trips_screen.dart';
import 'package:travel_buddy/screens/previous_trips_screen.dart';
import 'package:travel_buddy/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String _selectedVersion = 'Version 1.0';
  final List<String> _versions = ['Version 1.0', 'Version 1.1', 'Version 1.2', 'Beta 2.0'];

  @override
  Widget build(BuildContext context) {
    // Determine display name and email
    final String email = user?.email ?? 'No Email';
    final String username = (user?.displayName != null && user!.displayName!.isNotEmpty) 
        ? user!.displayName! 
        : (email.contains('@') ? email.split('@').first : 'Guest');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Avatar & User Info ---
            ValueListenableBuilder<String?>(
              valueListenable: ProfileImageProvider().imagePath,
              builder: (context, path, child) {
                 return CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: path != null ? FileImage(File(path)) : null,
                  child: path == null 
                      ? const Icon(Icons.person, size: 60, color: Colors.blueAccent)
                      : null,
                );
              }
            ),
            const SizedBox(height: 12),
            Text(
              username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // --- Menu Items ---
            // Note: "Profile" option removed as requested ("exclude the profile option below")
            
            ProfileMenuItem(
              icon: Icons.bookmark_outline,
              text: 'Bookmarked',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkedTripsScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.flight_takeoff_outlined,
              text: 'Previous Trips',
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PreviousTripsScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              text: 'Settings',
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) => setState(() {}));
              },
            ),
            
            // --- Version Dropdown ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12),
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey.shade300),
                   borderRadius: BorderRadius.circular(8),
                 ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: const Icon(Icons.info_outline, color: Colors.grey),
                    value: _selectedVersion,
                    items: _versions.map((String version) {
                      return DropdownMenuItem<String>(
                        value: version,
                        child: Text(version, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedVersion = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable widget for list items ---
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ProfileMenuItem({required this.icon, required this.text, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

