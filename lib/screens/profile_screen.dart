import 'dart:io';
import 'dart:io';
import 'package:travel_buddy/services/database_service.dart';
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
  
  String? _username;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      final profile = await DatabaseService.getUserProfile(user!.uid);
      if (profile != null) {
        setState(() {
          _username = profile['username'];
          _photoUrl = profile['photoUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine display name and email
    final String email = user?.email ?? 'No Email';
    final String displayUsername = _username ?? (user?.displayName != null && user!.displayName!.isNotEmpty
        ? user!.displayName!
        : (email.contains('@') ? email.split('@').first : 'Guest'));

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
              ).then((_) {
                 _loadUserProfile(); // Reload after editing
                 setState(() {});
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Avatar & User Info ---
            // Use local state _photoUrl if available, else fallback to ProfileImageProvider/file
             CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: _photoUrl != null 
                  ? FileImage(File(_photoUrl!)) // Assuming local path is stored for now
                  : null, 
              child: _photoUrl == null 
                  ? const Icon(Icons.person, size: 60, color: Colors.blueAccent)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              displayUsername,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // --- Menu Items ---
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
                ).then((_) {
                   _loadUserProfile(); // Verify sync
                   setState(() {});
                });
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

