import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isFormValid;
  final String? errorMessage;

  const RegisterState({
    this.name = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.isFormValid = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isFormValid,
    String? errorMessage,
  }) {
    return RegisterState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [name, username, email, password, isSubmitting, errorMessage];
}
