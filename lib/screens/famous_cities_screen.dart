import 'package:flutter/material.dart';
import '../models/city.dart'; // Ensure model is imported (usually implicitly available but good to be explicit if separated)
import '../services/database_service.dart';
import 'city_map_screen.dart';

class FamousCitiesScreen extends StatelessWidget {
  const FamousCitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local list logic removed


    return Scaffold(
      appBar: AppBar(
        title: const Text('Famous Destinations'), // Changed title
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<City>>(
        future: DatabaseService.getAllCities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final famousDestinations = snapshot.data ?? [];
          
          if (famousDestinations.isEmpty) {
            return const Center(child: Text("No famous cities found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: famousDestinations.length,
            itemBuilder: (context, index) {
              final city = famousDestinations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityMapScreen(city: city),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          city.imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.broken_image, size: 50)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // City/Destination Name
                            Text(
                              city.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Text(
                              city.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                             // Landmark count
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  '${city.landmarks.length} Landmarks',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
