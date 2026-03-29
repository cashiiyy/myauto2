import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _selectedGender = 'Not Specified';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone.isNotEmpty ? widget.user.phone : ''); 
    _addressController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _isLoading = true);
    
    final updatedUser = UserModel(
      uid: widget.user.uid,
      email: _emailController.text.trim(),
      role: widget.user.role,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      createdAt: widget.user.createdAt,
      isVerified: widget.user.isVerified,
      autoRegistrationNumber: widget.user.autoRegistrationNumber,
      licenseNumber: widget.user.licenseNumber,
      driverPhotoUrl: widget.user.driverPhotoUrl,
      autoPhotoUrl: widget.user.autoPhotoUrl,
      latitude: widget.user.latitude,
      longitude: widget.user.longitude,
      isAvailable: widget.user.isAvailable,
    );

    // Update Firestore
    await ref.read(authControllerProvider.notifier).createUserDocument(updatedUser);
    
    // Update local session
    ref.read(localSessionProvider.notifier).state = updatedUser;

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile details updated successfully!'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _isLoading 
            ? const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())))
            : TextButton(
                onPressed: _save,
                child: Text('Save', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
              )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera/Gallery access not available in demo'))
                      );
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Home Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.wc_outlined),
              ),
              items: ['Not Specified', 'Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedGender = val);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
