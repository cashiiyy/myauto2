class UserModel {
  final String uid;
  final String email;
  final String role; // 'passenger' or 'driver'
  final String name;
  final String phone;
  final DateTime createdAt;

  // Passenger Specific (Optional)
  final bool isVerified;
  final bool isRequesting; // True when actively looking for an auto

  // Driver Specific (Optional)
  final String? autoRegistrationNumber;
  final String? licenseNumber;
  final String? driverPhotoUrl;
  final String? autoPhotoUrl;
  final double? latitude;
  final double? longitude;
  final bool? isAvailable;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    required this.createdAt,
    this.isVerified = false,
    this.isRequesting = false,
    this.autoRegistrationNumber,
    this.licenseNumber,
    this.driverPhotoUrl,
    this.autoPhotoUrl,
    this.latitude,
    this.longitude,
    this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'isRequesting': isRequesting,
      if (autoRegistrationNumber != null) 'autoRegistrationNumber': autoRegistrationNumber,
      if (licenseNumber != null) 'licenseNumber': licenseNumber,
      if (driverPhotoUrl != null) 'driverPhotoUrl': driverPhotoUrl,
      if (autoPhotoUrl != null) 'autoPhotoUrl': autoPhotoUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isAvailable != null) 'isAvailable': isAvailable,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      email: map['email'] ?? '',
      role: map['role'] ?? 'passenger',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      isVerified: map['isVerified'] ?? false,
      isRequesting: map['isRequesting'] ?? false,
      autoRegistrationNumber: map['autoRegistrationNumber'],
      licenseNumber: map['licenseNumber'],
      driverPhotoUrl: map['driverPhotoUrl'],
      autoPhotoUrl: map['autoPhotoUrl'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      isAvailable: map['isAvailable'],
    );
  }
}
