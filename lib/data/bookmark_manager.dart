import 'package:flutter/material.dart';
import '../models/explore_trips.dart';

class BookmarkManager {
  static final BookmarkManager _instance = BookmarkManager._internal();

  factory BookmarkManager() {
    return _instance;
  }

  BookmarkManager._internal();

  final ValueNotifier<List<ExploreTrip>> bookmarkedTrips = ValueNotifier([]);

  void addBookmark(ExploreTrip trip) {
    if (!isBookmarked(trip)) {
      final currentList = List<ExploreTrip>.from(bookmarkedTrips.value);
      currentList.add(trip);
      bookmarkedTrips.value = currentList;
    }
  }

  void removeBookmark(ExploreTrip trip) {
    final currentList = List<ExploreTrip>.from(bookmarkedTrips.value);
    currentList.removeWhere((t) => t.id == trip.id);
    bookmarkedTrips.value = currentList;
  }

  bool isBookmarked(ExploreTrip trip) {
    return bookmarkedTrips.value.any((t) => t.id == trip.id);
  }
}
