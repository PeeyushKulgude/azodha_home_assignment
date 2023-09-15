import 'package:contacts/features/homepage/presentation/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../add_contact/presentation/pages/add_contact.dart';
import '../widgets/contact_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ContactsBloc contactsBloc = ContactsBloc();

  @override
  void initState() {
    contactsBloc.add(ContactsInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contacts",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        bloc: contactsBloc,
        listenWhen: (previous, current) => current is ContactsActionState,
        buildWhen: (previous, current) => current is! ContactsActionState,
        listener: (BuildContext context, ContactsState state) {
          if (state is NavigateToAddContactPage) {
            showBottomSheet(
              context: context,
              builder: (context) => AddContact(contactsBloc: contactsBloc),
            );
          }
          if (state is NavigateToEditContact) {
            showBottomSheet(
              context: context,
              builder: (context) => AddContact(contactsBloc: contactsBloc, editContact: state.contact),
            );
          }
        },
        builder: (BuildContext context, ContactsState state) {
          if (state is ContactsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContactsLoadedSuccess) {
            if (state.contacts.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Press the + button to add a contact",
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  LottieBuilder.asset('assets/animations/arrow.json'),
                ],
              );
            }
            return BlocProvider.value(
              value: contactsBloc,
              child: ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContactTile(contact: state.contacts[index]);
                },
              ),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => contactsBloc.add(AddContactButtonPressedEvent()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
