import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'auth_provider.dart';

final locationServiceProvider = Provider((ref) => LocationService());

// A StreamProvider that listens to location changes and updates Firestore automatically
final currentLocationProvider = StreamProvider<Position?>((ref) async* {
  final locationService = ref.watch(locationServiceProvider);
  final user = ref.watch(authStateProvider).value;
  final firestore = ref.watch(firestoreProvider);

  // First, get an initial position so the UI renders quickly
  final initialPos = await locationService.getCurrentLocation();
  if (initialPos != null) {
    yield initialPos;
  }

  // Then start listening to continuous updates
  await for (final position in Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // only update if they moved 10 meters
    ),
  )) {
    yield position;
    
    // Background sync to Firestore if user is authenticated
    if (user != null && firestore != null) {
      firestore.collection('users').doc(user.uid).update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      }).catchError((e) {
        // Silently catch errors if the document doesn't exist yet during signup
      });
    }
  }
});
