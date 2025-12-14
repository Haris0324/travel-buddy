import '../models/explore_trips.dart';

const String mountainUrl = 'https://th-thumbnailer.cdn-si-edu.com/6yMY8_cgAbXs3lUO1WArpsqa4iQ=/960x439/filters:focal(2871x1449:2872x1450)/https://tf-cmsv2-journeys-media.s3.amazonaws.com/filer/40/0f/400fcf32-04a6-4b05-b1f7-29bf84024e40/swz_matterhorn_train_ss_704449474_lr_copy.jpg';

final List<ExploreTrip> exploreTrips = [
  const ExploreTrip(
    id: 'e1',
    name: 'Swiss Alps Hiking',
    location: 'Interlaken, Switzerland',
    imageUrl: 'https://th-thumbnailer.cdn-si-edu.com/6yMY8_cgAbXs3lUO1WArpsqa4iQ=/960x439/filters:focal(2871x1449:2872x1450)/https://tf-cmsv2-journeys-media.s3.amazonaws.com/filer/40/0f/400fcf32-04a6-4b05-b1f7-29bf84024e40/swz_matterhorn_train_ss_704449474_lr_copy.jpg',
    visitingPlaces: [
      'Jungfraujoch (Top of Europe)',
      'Lake Brienz',
      'Harder Kulm Viewpoint',
      'Grindelwald Village',
      'Trummelbach Falls',
    ],
  ),
  const ExploreTrip(
    id: 'e2',
    name: 'Bali Retreat',
    location: 'Ubud, Indonesia',
    imageUrl: 'https://i.pinimg.com/1200x/0d/8e/5a/0d8e5ae314cfd1420857f9872cbac45f.jpg',
    visitingPlaces: [
      'Sacred Monkey Forest Sanctuary',
      'Tegalalang Rice Terrace',
      'Tirta Empul Temple',
      'Ubud Art Market',
      'Campuhan Ridge Walk',
    ],
  ),
  const ExploreTrip(
    id: 'e3',
    name: 'Kyoto Tour',
    location: 'Kyoto, Japan',
    imageUrl: 'https://i.pinimg.com/736x/4f/b1/c9/4fb1c99d71db0f1f120f7fcbbe5e405e.jpg',
    visitingPlaces: [
      'Fushimi Inari Shrine',
      'Kinkaku-ji (Golden Pavilion)',
      'Arashiyama Bamboo Grove',
      'Gion District',
      'Kiyomizu-dera Temple',
    ],
  ),
  const ExploreTrip(
    id: 'e4',
    name: 'Sahara Camp',
    location: 'Merzouga, Morocco',
    imageUrl: 'https://travel.rakuten.com/contents/sites/contents/files/styles/max_1300x1300/public/2023-05/7-day-itinerary-kyoto_9.jpg?itok=KOCC0A8K',
    visitingPlaces: [
      'Erg Chebbi Dunes',
      'Khamlia Village (Gnawa Music)',
      'Todra Gorge',
      'Rissani Market',
      'Merzouga Lake',
    ],
  ),
];