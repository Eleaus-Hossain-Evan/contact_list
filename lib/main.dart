import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: const ContactList(
        contacts: [
          Contact('Alice', '123456789'),
          Contact('Bob', '234567891'),
          Contact('Charlie', '345678912'),
          Contact('David', '456789123'),
        ],
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({
    super.key,
    required this.contacts,
  });

  final List<Contact> contacts;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    widget.contacts.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts'),
        bottom: SearchWidget(controller: controller),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, text, child) {
          var filteredContacts = text.text.isEmpty
              ? widget.contacts
              : widget.contacts
                  .where((contact) => contact.name
                      .toLowerCase()
                      .contains(text.text.toLowerCase()))
                  .toList();

          return ListView.builder(
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
              );
            },
          );
        },
      ),
    );
  }
}

class SearchWidget extends StatelessWidget implements PreferredSizeWidget {
  const SearchWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Search',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Contact {
  final String name;
  final String phoneNumber;

  const Contact(this.name, this.phoneNumber);
}
