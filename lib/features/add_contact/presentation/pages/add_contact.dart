import 'package:contacts/features/add_contact/presentation/bloc/add_contact_bloc.dart';
import 'package:contacts/features/homepage/presentation/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../homepage/data/models/contact_model.dart';

/// A Flutter widget representing the screen for adding or editing a contact.
///
/// The `AddContact` widget allows users to input contact details such as name,
/// phone number, email, and address. It supports both adding new contacts and
/// editing existing ones. The widget utilizes the `AddContactBloc` for managing
/// the state of the contact addition or editing process.
class AddContact extends StatefulWidget {
  /// The [ContactsBloc] used for managing contact-related state in the parent widget.
  final ContactsBloc contactsBloc;

  /// The contact to edit. If `null`, a new contact will be added.
  final Contact? editContact;

  /// Creates a new [AddContact] widget.
  ///
  /// The [contactsBloc] parameter is required and represents the parent widget's
  /// [ContactsBloc] for managing contact-related state.
  ///
  /// The [editContact] parameter is optional and represents the contact to edit.
  /// If provided, the widget will initialize with the contact's details for editing.
  const AddContact({super.key, required this.contactsBloc, this.editContact});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // Create an instance of the AddContactBloc to manage the contact addition or editing process.
  final AddContactBloc addContactBloc = AddContactBloc();

  // Global key for the form to access and validate form fields.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers for input fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Regular expression for validating email addresses.
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    addContactBloc.add(AddContactInitialEvent());

    // Initialize input fields with contact details if editing an existing contact.
    if (widget.editContact != null) {
      nameController.text = widget.editContact!.name;
      emailController.text = widget.editContact!.email;
      phoneController.text = widget.editContact!.phone;
      addressController.text = widget.editContact!.address;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: addContactBloc,
      listener: (context, state) {
        // Listen for state changes and trigger actions based on the state.
        if (state is AddContactSuccess) {
          // If contact addition or editing is successful, refresh the contacts list and close the page.
          Future.delayed(const Duration(seconds: 1), () {
            widget.contactsBloc.add(ContactsInitialEvent());
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        if (state is AddContactInitial) {
          // Display the contact input form when in the initial state.
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Input field for name.
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a name';
                      } else if (value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: InternationalPhoneNumberInput(
                      validator: (phoneNumber) {
                        if (phoneNumber == null || phoneNumber.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        int sum = 0;
                        phoneNumber.split(' ').forEach((element) {
                          sum += element.length;
                        });
                        if (sum != 10) {
                          return 'Phone number must have 10 digits';
                        }
                        return null;
                      },
                      initialValue: PhoneNumber(isoCode: 'IN'),
                      onInputChanged: (PhoneNumber number) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      ignoreBlank: false,
                      textFieldController: phoneController,
                      formatInput: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true, decimal: true),
                    ),
                  ),
                  // Input field for email (optional).
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email (Optional)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  // Input field for address (optional).
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address (Optional)'),
                    onFieldSubmitted: (value) {
                      if (formKey.currentState!.validate()) {
                        // Trigger the submit event when the form is valid and submitted.
                        addContactBloc.add(
                          SubmitButtonPressedEvent(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Submit button.
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Trigger the submit event when the form is valid.
                        addContactBloc.add(
                          SubmitButtonPressedEvent(
                            id: widget.editContact?.id,
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AddContactLoading) {
          // Display a loading indicator when the contact addition or editing is in progress.
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AddContactSuccess) {
          // Display a success message when the contact addition or editing is successful.
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Center(
                child: Text("Contact added successfully"),
              ),
            ],
          );
        } else if (state is AddContactFailure) {
          // Display an error message when there is a failure in adding or editing the contact.
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(state.message),
              ),
            ],
          );
        } else {
          // Display a generic error message if something unexpected happens.
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }
}
