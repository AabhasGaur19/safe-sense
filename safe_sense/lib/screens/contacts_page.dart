import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../models/sos_contact.dart';
import '../utils/helpers.dart';

class ContactsPage extends StatefulWidget {
  final List<SOSContact> initialContacts;
  const ContactsPage({super.key, required this.initialContacts});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late List<SOSContact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = List.from(widget.initialContacts);
  }

  Future<void> _pickContact() async {
    // Check the status of the contacts permission
    PermissionStatus status = await Permission.contacts.status;

    // If permission is not granted, request it
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    // Check the final status and act accordingly
    if (status.isGranted) {
      // Permission is granted, proceed to open the contact picker
      try {
        Contact? contact = await FlutterContacts.openExternalPick();

        if (contact != null && contact.phones.isNotEmpty) {
          bool exists = _contacts.any((c) => c.number == contact.phones.first.number);
          if (exists) {
            showMessage(context, "${contact.displayName} is already in the list.", 
                       color: Colors.orange);
            return;
          }
          setState(() {
            _contacts.add(SOSContact(
              name: contact.displayName,
              number: contact.phones.first.number,
            ));
          });
        }
      } catch (e) {
        showMessage(context, "Failed to pick contact: ${e.toString()}");
      }
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, show a dialog to open app settings
      showMessage(context, "Contact permission is permanently denied. Please enable it in settings.");
      openAppSettings();
    } else {
      // If permission is just denied, show the message
      showMessage(context, "Contact permission is required to add contacts.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Contacts'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _contacts),
        ),
      ),
      body: _contacts.isEmpty
          ? const Center(child: Text("No contacts added yet."))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.number),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _contacts.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}