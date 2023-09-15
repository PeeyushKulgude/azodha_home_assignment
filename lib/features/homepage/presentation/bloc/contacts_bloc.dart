import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../data/models/contact_model.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsInitial()) {
    on<ContactsInitialEvent>(contactsInitialEvent);
    on<AddContactButtonPressedEvent>(addContactButtonPressedEvent);
    on<DeleteContactButtonPressedEvent>(deleteContactButtonPressedEvent);
    on<EditContactButtonPressedEvent>(editContactButtonPressedEvent);
  }

  FutureOr<void> contactsInitialEvent(
      ContactsInitialEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    await FirebaseFirestore.instance
        .collection('contacts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      final List<Contact> contacts = [];
      for (var doc in querySnapshot.docs) {
        contacts.add(Contact.fromJson(doc.data() as Map<String, dynamic>));
      }
      emit(ContactsLoadedSuccess(contacts: contacts));
    });
  }

  FutureOr<void> addContactButtonPressedEvent(
      AddContactButtonPressedEvent event, Emitter<ContactsState> emit) async {
    emit(NavigateToAddContactPage());
  }

  FutureOr<void> deleteContactButtonPressedEvent(
      DeleteContactButtonPressedEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    await FirebaseFirestore.instance.collection('contacts').doc(event.contact.id).delete();
    add(ContactsInitialEvent());
  }

  FutureOr<void> editContactButtonPressedEvent(
      EditContactButtonPressedEvent event, Emitter<ContactsState> emit) async {
    emit(NavigateToEditContact(contact: event.contact));
  }
}
