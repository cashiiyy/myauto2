import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool pushNotifications = true;
  bool locationTracking = true;
  bool smsAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile('Push Notifications', 'Receive alerts for rides and updates.', pushNotifications, (val) {
            setState(() => pushNotifications = val);
          }),
          _buildSwitchTile('Location Tracking Background', 'Keep location exact while app is minimized.', locationTracking, (val) {
            setState(() => locationTracking = val);
          }),
          _buildSwitchTile('SMS Alerts', 'Receive text messages.', smsAlerts, (val) {
            setState(() => smsAlerts = val);
          }),
          const Divider(height: 32),
          
          // SOS Configuration Tile
          Consumer(
            builder: (context, ref, _) {
              final sosNumber = ref.watch(sosContactProvider);
              return ListTile(
                title: const Text('Emergency SOS Contact', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                subtitle: Text('Currently set to: $sosNumber'),
                trailing: const Icon(Icons.edit, size: 20, color: Colors.redAccent),
                onTap: () => _showSosEditDialog(context, ref, sosNumber),
              );
            }
          ),
          
          const Divider(height: 32),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English (US)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).primaryColor,
    );
  }

  void _showSosEditDialog(BuildContext context, WidgetRef ref, String currentNumber) {
    final controller = TextEditingController(text: currentNumber);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set SOS Contact'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Enter emergency number (e.g. 100)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newNumber = controller.text.trim();
              if (newNumber.isNotEmpty) {
                ref.read(sosContactProvider.notifier).state = newNumber;
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
