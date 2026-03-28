import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_provider.dart';

class SafetyContactsScreen extends ConsumerStatefulWidget {
  const SafetyContactsScreen({super.key});

  @override
  ConsumerState<SafetyContactsScreen> createState() => _SafetyContactsScreenState();
}

class _SafetyContactsScreenState extends ConsumerState<SafetyContactsScreen> {
  void _showAddContactDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                ref.read(userProfileProvider.notifier).addContact(
                  SafetyContact(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    phone: phoneCtrl.text,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(userProfileProvider).contacts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Contacts', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddContactDialog,
          )
        ],
      ),
      body: contacts.isEmpty
        ? const Center(child: Text('No safety contacts added yet.'))
        : ListView.builder(
            itemCount: contacts.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(userProfileProvider.notifier).removeContact(contact.id);
                    },
                  ),
                ),
              );
            },
          ),
    );
  }
}
