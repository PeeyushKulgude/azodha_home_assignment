part of 'contacts_bloc.dart';

@immutable
sealed class ContactsState {}

abstract class ContactsActionState extends ContactsState {}

final class ContactsInitial extends ContactsState {}

final class ContactsLoading extends ContactsState {}

final class ContactsLoadedSuccess extends ContactsState {
  final List<Contact> contacts;

  ContactsLoadedSuccess({required this.contacts});
}

final class NavigateToAddContactPage extends ContactsActionState {}

final class NavigateToEditContact extends ContactsActionState {
  final Contact contact;

  NavigateToEditContact({required this.contact});
}

