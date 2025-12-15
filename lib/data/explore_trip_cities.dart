import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/city.dart';

// Mapping ExploreTrip IDs to City objects manually
// e1: Swiss Alps -> Interlaken
// e2: Bali Retreat -> Ubud
// e3: Kyoto Tour -> Kyoto
// e4: Sahara Camp -> Merzouga

final Map<String, City> exploreTripCities = {
  'e1': City(
    name: 'Interlaken',
    description: 'A traditional resort town in the mountainous Bernese Oberland region of central Switzerland.',
    // Updated URL
    imageUrl: 'https://th-thumbnailer.cdn-si-edu.com/6yMY8_cgAbXs3lUO1WArpsqa4iQ=/960x439/filters:focal(2871x1449:2872x1450)/https://tf-cmsv2-journeys-media.s3.amazonaws.com/filer/40/0f/400fcf32-04a6-4b05-b1f7-29bf84024e40/swz_matterhorn_train_ss_704449474_lr_copy.jpg',
    coordinates: const LatLng(46.6863, 7.8632),
    landmarks: [
      Landmark(name: 'Harder Kulm', location: const LatLng(46.6970, 7.8630)),
      Landmark(name: 'Lake Thun', location: const LatLng(46.7200, 7.7100)),
      Landmark(name: 'Lake Brienz', location: const LatLng(46.7300, 7.9600)),
      Landmark(name: 'Jungfraujoch', location: const LatLng(46.5475, 7.9850)),
      Landmark(name: 'Höhematte Park', location: const LatLng(46.6865, 7.8580)),
      Landmark(name: 'St. Beatus Caves', location: const LatLng(46.6830, 7.7800)),
    ],
  ),
  'e2': City(
    name: 'Ubud',
    description: 'A town on the Indonesian island of Bali in Ubud District.',
    // Updated URL
    imageUrl: 'https://i.pinimg.com/1200x/0d/8e/5a/0d8e5ae314cfd1420857f9872cbac45f.jpg',
    coordinates: const LatLng(-8.5069, 115.2625),
    landmarks: [
      Landmark(name: 'Sacred Monkey Forest Sanctuary', location: const LatLng(-8.5194, 115.2606)),
      Landmark(name: 'Tegalalang Rice Terrace', location: const LatLng(-8.4294, 115.2798)),
      Landmark(name: 'Campuhan Ridge Walk', location: const LatLng(-8.5034, 115.2530)),
      Landmark(name: 'Ubud Art Market', location: const LatLng(-8.5073, 115.2629)),
      Landmark(name: 'Goa Gajah', location: const LatLng(-8.5234, 115.2863)),
    ],
  ),
  'e3': City(
    name: 'Kyoto',
    description: 'Once the capital of Japan, it is a city on the island of Honshu.',
    // Updated URL
    imageUrl: 'https://i.pinimg.com/736x/4f/b1/c9/4fb1c99d71db0f1f120f7fcbbe5e405e.jpg',
    coordinates: const LatLng(35.0116, 135.7681),
    landmarks: [
      Landmark(name: 'Kinkaku-ji', location: const LatLng(35.0394, 135.7292)),
      Landmark(name: 'Fushimi Inari-taisha', location: const LatLng(34.9671, 135.7727)),
      Landmark(name: 'Arashiyama Bamboo Grove', location: const LatLng(35.0094, 135.6670)),
      Landmark(name: 'Kiyomizu-dera', location: const LatLng(34.9949, 135.7850)),
      Landmark(name: 'Nijō Castle', location: const LatLng(35.0142, 135.7482)),
    ],
  ),
  'e4': City(
    name: 'Merzouga',
    description: 'A small village in southeastern Morocco, about 35 km southeast of Rissani.',
    // Updated URL
    imageUrl: 'https://travel.rakuten.com/contents/sites/contents/files/styles/max_1300x1300/public/2023-05/7-day-itinerary-kyoto_9.jpg?itok=KOCC0A8K',
    coordinates: const LatLng(31.0802, -4.0133),
    landmarks: [
      Landmark(name: 'Erg Chebbi', location: const LatLng(31.1000, -3.9833)),
      Landmark(name: 'Dayet Srji', location: const LatLng(31.0833, -4.0333)),
      Landmark(name: 'Merzouga Dune', location: const LatLng(31.0900, -4.0100)),
      Landmark(name: 'Hassilabied', location: const LatLng(31.1333, -4.0167)),
      Landmark(name: 'Khamlia', location: const LatLng(31.0333, -4.0000)),
    ],
  ),
};
