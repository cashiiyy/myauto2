import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auto_model.dart';

final firestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (Firebase.apps.isNotEmpty) {
    return FirebaseFirestore.instance;
  }
  return null;
});

// A robust StreamProvider that hooks into Firestore and listens for any User
// that is registered as a "driver". Falls back to mock data if Firebase is not initialized.
final autoListStreamProvider = StreamProvider<List<AutoModel>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  
  if (firestore == null) {
    // Return mock data for UI testing when Firebase is not configured (e.g., on Web)
    return Stream.value([
      AutoModel(id: 'mock_1', latitude: 8.5241, longitude: 76.9366, isAvailable: true, driverName: 'Mock Driver A', phoneNumber: '123', vehicleNumber: 'KL-01-MOCK', rating: 4.8),
      AutoModel(id: 'mock_2', latitude: 8.5300, longitude: 76.9400, isAvailable: true, driverName: 'Mock Driver B', phoneNumber: '456', vehicleNumber: 'KL-02-TEST', rating: 4.5),
    ]);
  }

  return firestore
    .collection('users')
    .where('role', isEqualTo: 'driver')
    .where('isAvailable', isEqualTo: true)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AutoModel(
          id: doc.id,
          latitude: data['latitude']?.toDouble() ?? 0.0,
          longitude: data['longitude']?.toDouble() ?? 0.0,
          isAvailable: data['isAvailable'] ?? false,
          driverName: data['name'] ?? 'Driver',
          phoneNumber: data['phone'] ?? '',
          vehicleNumber: data['autoRegistrationNumber'] ?? '',
          rating: 5.0, // Default for now
        );
      }).toList();
  });
});

// A StreamProvider that listens to passengers actively requesting a ride.
// Used by Drivers to see where passengers are.
final activePassengerListStreamProvider = StreamProvider<List<AutoModel>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  
  if (firestore == null) {
    return Stream.value([]); // No mock passengers yet
  }

  return firestore
    .collection('users')
    .where('role', isEqualTo: 'passenger')
    .where('isRequesting', isEqualTo: true)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AutoModel(
          id: doc.id,
          latitude: data['latitude']?.toDouble() ?? 0.0,
          longitude: data['longitude']?.toDouble() ?? 0.0,
          isAvailable: true, // They are actively requesting
          driverName: data['name'] ?? 'Passenger',
          phoneNumber: data['phone'] ?? '',
          vehicleNumber: 'N/A', // Passengers don't have vehicles
          rating: 5.0,
        );
      }).toList();
  });
});
