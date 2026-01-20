import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class NameChanged extends RegisterEvent {
  final String name;
  const NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class UsernameChanged extends RegisterEvent {
  final String username;
  const UsernameChanged(this.username);
  @override
  List<Object?> get props => [username];
}

class EmailChanged extends RegisterEvent {
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {}
