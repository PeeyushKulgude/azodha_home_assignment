import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';

import '../../../homepage/data/models/contact_model.dart';

part 'add_contact_event.dart';
part 'add_contact_state.dart';

class AddContactBloc extends Bloc<AddContactEvent, AddContactState> {
  AddContactBloc() : super(AddContactInitial()) {
    on<AddContactInitialEvent>(onAddContactInitialEvent);
    on<SubmitButtonPressedEvent>(onSubmitButtonPressedEvent);
  }

  FutureOr<void> onAddContactInitialEvent(
    AddContactInitialEvent event,
    Emitter<AddContactState> emit,
  ) async {
    emit(AddContactInitial());
  }

  FutureOr<void> onSubmitButtonPressedEvent(
    SubmitButtonPressedEvent event,
    Emitter<AddContactState> emit,
  ) async {
    emit(AddContactLoading());
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw (Exception('No internet connection'));
      }

      final ref = event.id ?? FirebaseFirestore.instance.collection('contacts').doc().id;
      final Contact contact = Contact(
        id: ref,
        name: event.name,
        email: event.email,
        phone: event.phone,
        address: event.address,
      );
      await FirebaseFirestore.instance.collection('contacts').doc(ref).set(contact.toJson());
      emit(AddContactSuccess(contact: contact));
    } catch (e) {
      emit(AddContactFailure(message: e.toString()));
    }
  }
}
