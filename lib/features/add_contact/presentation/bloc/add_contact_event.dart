part of 'add_contact_bloc.dart';

@immutable
sealed class AddContactEvent {}

final class AddContactInitialEvent extends AddContactEvent {}

final class SubmitButtonPressedEvent extends AddContactEvent {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;

  SubmitButtonPressedEvent({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}
