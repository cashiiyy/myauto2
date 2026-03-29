import 'dart:math';
import '../models/auto_model.dart';

class AutoService {
  final Random _random = Random();

  // Generates dummy autos around a central location
  List<AutoModel> getMockAutos(double centerLat, double centerLng) {
    List<AutoModel> autos = [];
    for (int i = 0; i < 10; i++) {
      // Randomly disperse within small radius
      double offsetLat = (_random.nextDouble() - 0.5) * 0.02;
      double offsetLng = (_random.nextDouble() - 0.5) * 0.02;
      
      autos.add(
        AutoModel(
          id: 'auto_$i',
          latitude: centerLat + offsetLat,
          longitude: centerLng + offsetLng,
          isAvailable: _random.nextBool(),
          driverName: 'Driver $i',
          phoneNumber: '+91987654321$i',
          vehicleNumber: 'KL-01-AB-123$i',
          rating: 4.0 + (_random.nextDouble()),
        ),
      );
    }
    return autos;
  }
}
