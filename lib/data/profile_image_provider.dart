import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageProvider {
  static final ProfileImageProvider _instance = ProfileImageProvider._internal();

  factory ProfileImageProvider() {
    return _instance;
  }

  ProfileImageProvider._internal();

  final ValueNotifier<String?> imagePath = ValueNotifier(null);
  static const String _key = 'profile_image_path';

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    imagePath.value = prefs.getString(_key);
  }

  Future<void> setProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
    imagePath.value = path;
  }

  Future<void> clearProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    imagePath.value = null;
  }
}
