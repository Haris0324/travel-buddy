import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../data/profile_image_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  
  // Controllers
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _loadedPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Pre-fill from Firebase Auth
      _usernameController.text = (user.displayName != null && user.displayName!.isNotEmpty) 
          ? user.displayName! 
          : (user.email != null ? user.email!.split('@').first : '');

      // 2. Load from Realtime Database (for photo & potentially updated name)
      final profile = await DatabaseService.getUserProfile(user.uid);
      if (profile != null) {
        setState(() {
          if (profile['username'] != null) _usernameController.text = profile['username'];
          _loadedPhotoUrl = profile['photoUrl'];
        });
        // Sync local provider for immediate UI feedback if needed, 
        // but mostly we rely on _loadedPhotoUrl for this screen's source of truth now.
        if (_loadedPhotoUrl != null) {
          ProfileImageProvider().setProfileImage(_loadedPhotoUrl!);
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Update local provider (optional, but keeps UI snappy)
      await ProfileImageProvider().setProfileImage(image.path);
      
      setState(() {
        _loadedPhotoUrl = image.path;
      });

      // SAVE TO FIREBASE
      final user = _auth.currentUser;
      if (user != null) {
        await DatabaseService.saveUserProfile(user.uid, {
          'photoUrl': image.path,
          'username': _usernameController.text, // keep existing name
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          // Update Firebase Auth Display Name
          if (_usernameController.text.isNotEmpty && _usernameController.text != user.displayName) {
             await user.updateDisplayName(_usernameController.text);
          }

          // Update Password (if provided)
          if (_passwordController.text.isNotEmpty) {
            await user.updatePassword(_passwordController.text);
          }

          // Update Realtime Database
          await DatabaseService.saveUserProfile(user.uid, {
            'username': _usernameController.text,
            'photoUrl': _loadedPhotoUrl, // Persist current photo path
            // Add phone if you want: 'phone': _phoneController.text
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               // --- Profile Picker ---
              Center(
                child: Stack(
                  children: [
                    // Display image from local state (which syncs from DB/Picker)
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _loadedPhotoUrl != null 
                          ? FileImage(File(_loadedPhotoUrl!)) 
                          : null,
                      child: _loadedPhotoUrl == null 
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Account Settings', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Username', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: '+1 234 567 8900'
                ),
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'New password',
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Leave empty to keep current password', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
