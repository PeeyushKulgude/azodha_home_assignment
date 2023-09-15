part of 'add_contact_bloc.dart';

@immutable
sealed class AddContactState {}

final class AddContactInitial extends AddContactState {}

final class AddContactLoading extends AddContactState {}

final class AddContactSuccess extends AddContactState {
  final Contact contact;

  AddContactSuccess({required this.contact});
}

final class AddContactFailure extends AddContactState {
  final String message;

  AddContactFailure({required this.message});
}
