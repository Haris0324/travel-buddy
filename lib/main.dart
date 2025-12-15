import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/wrapper.dart';
import 'package:travel_buddy/services/notification_service.dart';
import 'package:travel_buddy/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    await NotificationService.init();
    
    // Attempt seeding with a timeout so app doesn't hang indefinitely
    await DatabaseService.seedInitialData().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('Seeding timed out - continuing app startup');
      },
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
     );
  }
}