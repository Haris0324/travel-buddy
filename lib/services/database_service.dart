import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_trip.dart';
import '../models/explore_trips.dart';
import '../models/city.dart';
import '../data/seed_data.dart';

class DatabaseService {
  static final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // --- User Profile ---
  static Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.child('users/$uid/profile').update(data);
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _db.child('users/$uid/profile').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  // --- User Trips ---
  static Future<void> saveUserTrip(String userId, UserTrip trip) async {
    try {
      print('Attempting to save trip for user: $userId');
      await _db.child('users/$userId/trips/${trip.id}').set(trip.toMap());
      print('Trip saved successfully!');
    } catch (e) {
      print('Error saving trip: $e');
      rethrow;
    }
  }

  static Stream<List<UserTrip>> getUserTrips(String userId) {
    print('Listening for trips for user: $userId');
    return _db.child('users/$userId/trips').onValue.map((event) {
      print('Received trip data event: ${event.snapshot.value}');
      final data = event.snapshot.value;
      if (data == null) return [];
      
      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      return map.values.map((e) => UserTrip.fromMap(e as Map)).toList();
    });
  }

  // --- Explore / Public Data ---
  static Future<List<ExploreTrip>> getExploreTrips() async {
    print('Fetching explore trips...');
    try {
      final snapshot = await _db.child('public_data/explore_trips').get();
      print('Explore trips snapshot exists: ${snapshot.exists}');
      if (snapshot.exists) {
        final List<dynamic> list = snapshot.value as List<dynamic>;
        return list.map((e) => ExploreTrip.fromMap(e as Map)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching explore trips: $e');
      return [];
    }
  }

  // --- City Details ---
  static Future<City?> getCityDetails(String tripId) async {
    final snapshot = await _db.child('public_data/explore_cities/$tripId').get();
    if (snapshot.exists) {
      return City.fromMap(snapshot.value as Map);
    }
    return null;
  }

  static Future<List<City>> getAllCities() async {
    final snapshot = await _db.child('public_data/explore_cities').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
      return map.values.map((e) => City.fromMap(e as Map)).toList();
    }
    return [];
  }

  // --- Seed Initial Data (Run once or if empty) ---
  static Future<void> seedInitialData() async {
    final snapshot = await _db.child('public_data').get();
    if (!snapshot.exists) {
      // Seed Explore Trips
      final exploreTripsMap = seedExploreTrips.map((e) => e.toMap()).toList();
      await _db.child('public_data/explore_trips').set(exploreTripsMap);

      // Seed Cities
      final Map<String, dynamic> citiesMap = {};
      seedCityData.forEach((key, city) {
        citiesMap[key] = city.toMap();
      });
      await _db.child('public_data/explore_cities').set(citiesMap);
      
      print('Initial data seeded to Firebase!');
    }
  }
}
