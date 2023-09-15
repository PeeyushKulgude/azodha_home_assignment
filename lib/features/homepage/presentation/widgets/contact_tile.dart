import 'package:contacts/features/homepage/data/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';

/// A Flutter widget that displays contact information in a card-like format.
///
/// The `ContactTile` widget is typically used within a list of contacts to
/// display each contact's name and phone number along with edit and delete
/// buttons.
class ContactTile extends StatelessWidget {
  /// The contact to display in the tile.
  final Contact contact;

  /// Creates a new [ContactTile] with the given [contact].
  ///
  /// The [contact] parameter is required and represents the contact whose
  /// information will be displayed by this tile.
  const ContactTile({super.key, required this.contact});

  /// Converts a given input string into a color.
  ///
  /// This method takes an input string, calculates its hash code, converts the
  /// hash code to a hexadecimal color code, and creates a [Color] object from
  /// the hexadecimal code. The resulting color is used to customize the
  /// appearance of the contact icon.
  Color stringToColor(String input) {
    int hashCode = input.hashCode;

    // Convert the hash code to a hexadecimal color code.
    String hexColor = hashCode.toUnsigned(32).toRadixString(16).padLeft(8, '0');

    // Create a Color object from the hexadecimal color code.
    Color color = Color(int.parse('FF$hexColor', radix: 16));

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 50,
              color: stringToColor(contact.phone).withAlpha(225),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(contact.phone),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<ContactsBloc>(context).add(
                  EditContactButtonPressedEvent(contact: contact),
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Contact"),
                    content: const Text("Are you sure you want to delete this contact?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<ContactsBloc>(context).add(
                            DeleteContactButtonPressedEvent(contact: contact),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
