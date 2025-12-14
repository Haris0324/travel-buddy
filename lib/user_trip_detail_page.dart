import 'package:flutter/material.dart';
import '../models/user_trip.dart';
import '../models/explore_trips.dart';
import '../data/explore_trips_data.dart'; // Needed to look up the image and places

class UserTripDetailPage extends StatelessWidget {
  final UserTrip trip;

  const UserTripDetailPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    // 1. Find the matching ExploreTrip to get the Image and Visiting Places
    // We search the static list for a trip where the name matches the user's destination
    final ExploreTrip? matchingExploreTrip = exploreTrips.cast<ExploreTrip?>().firstWhere(
          (element) => element?.name == trip.destination,
      orElse: () => null,
    );

    // Fallback data if no matching destination is found
    final String imageUrl = matchingExploreTrip?.imageUrl ??
        'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=2021&auto=format&fit=crop';

    final List<String> placesToVisit = matchingExploreTrip?.visitingPlaces ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                // Add edit logic here later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit feature coming soon!")),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Image ---
            Hero(
              tag: trip.id, // Ensure your UserTrip model has an 'id' field
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),

            // --- Trip Details Section ---
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip Name & Type Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip.tripName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 5),

                    // Destination Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          trip.destination,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // --- Info Grid (Dates, Budget, Travelers) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard(Icons.calendar_today, "Dates", "${trip.startDate}\n${trip.endDate}"),
                        _infoCard(Icons.attach_money, "Budget", "\$${trip.budget}"),
                        _infoCard(Icons.group, "Travelers", trip.travelers),
                      ],
                    ),

                    const SizedBox(height: 25),
                    const Divider(),
                    const SizedBox(height: 20),

                    // --- Visiting Places Section ---
                    if (placesToVisit.isNotEmpty) ...[
                      const Text(
                        "Planned Visiting Places",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: placesToVisit.map((place) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.map, color: Colors.orange, size: 20),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    place,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      // Fallback if no specific places found
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.edit_road, size: 40, color: Colors.grey[400]),
                            const SizedBox(height: 10),
                            Text(
                              "No specific itinerary yet.",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the info cards
  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6A5AE0), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87
            ),
          ),
        ],
      ),
    );
  }
}