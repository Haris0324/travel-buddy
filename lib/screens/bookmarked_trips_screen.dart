import 'package:flutter/material.dart';
import '../data/bookmark_manager.dart';
import '../models/explore_trips.dart';

class BookmarkedTripsScreen extends StatelessWidget {
  const BookmarkedTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bookmarked Trips', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<List<ExploreTrip>>(
        valueListenable: BookmarkManager().bookmarkedTrips,
        builder: (context, bookmarks, child) {
          if (bookmarks.isEmpty) {
            return const Center(
              child: Text('No bookmarked trips yet.', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final trip = bookmarks[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        trip.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(height: 150, color: Colors.grey[200], child: const Icon(Icons.error)),
                      ),
                    ),
                    ListTile(
                      title: Text(trip.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(trip.location),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          BookmarkManager().removeBookmark(trip);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from bookmarks')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
