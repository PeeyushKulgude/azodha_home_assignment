part of 'contacts_bloc.dart';

@immutable
sealed class ContactsEvent {}

final class ContactsInitialEvent extends ContactsEvent {}

final class AddContactButtonPressedEvent extends ContactsEvent {}

final class DeleteContactButtonPressedEvent extends ContactsEvent {
  final Contact contact;

  DeleteContactButtonPressedEvent({required this.contact});
}

final class EditContactButtonPressedEvent extends ContactsEvent {
  final Contact contact;

  EditContactButtonPressedEvent({required this.contact});
}