import 'package:flutter_riverpod/flutter_riverpod.dart';

class SafetyContact {
  final String id;
  final String name;
  final String phone;

  SafetyContact({required this.id, required this.name, required this.phone});
}

class UserProfile {
  final String name;
  final String email;
  final String profileMode; // 'Passenger mode'
  final List<SafetyContact> contacts;

  UserProfile({
    required this.name,
    required this.email,
    required this.profileMode,
    this.contacts = const [],
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileMode,
    List<SafetyContact>? contacts,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileMode: profileMode ?? this.profileMode,
      contacts: contacts ?? this.contacts,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile(
    name: 'Kasinathan p s',
    email: 'kasinathan@example.com',
    profileMode: 'Passenger mode',
    contacts: [
      SafetyContact(id: '1', name: 'Mom', phone: '+91 9876543210'),
    ],
  ));

  void updateName(String name) => state = state.copyWith(name: name);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updateProfileMode(String mode) => state = state.copyWith(profileMode: mode);
  void addContact(SafetyContact contact) {
    state = state.copyWith(contacts: [...state.contacts, contact]);
  }
  void removeContact(String id) {
    state = state.copyWith(
      contacts: state.contacts.where((c) => c.id != id).toList(),
    );
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

// Dynamic SOS Contact Provider (defaults to 100)
final sosContactProvider = StateProvider<String>((ref) => '100');
