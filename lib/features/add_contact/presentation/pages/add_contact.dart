import 'package:contacts/features/add_contact/presentation/bloc/add_contact_bloc.dart';
import 'package:contacts/features/homepage/presentation/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../homepage/data/models/contact_model.dart';

class AddContact extends StatefulWidget {
  final ContactsBloc contactsBloc;
  final Contact? editContact;
  const AddContact({super.key, required this.contactsBloc, this.editContact});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final AddContactBloc addContactBloc = AddContactBloc();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    addContactBloc.add(AddContactInitialEvent());
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
        if (state is AddContactSuccess) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            widget.contactsBloc.add(ContactsInitialEvent());
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        if (state is AddContactInitial) {
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        int sum = 0;
                        p0.split(' ').forEach((element) {
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
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address (Optional)'),
                    onFieldSubmitted: (value) {
                      if (formKey.currentState!.validate()) {
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
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AddContactSuccess) {
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
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }
}
