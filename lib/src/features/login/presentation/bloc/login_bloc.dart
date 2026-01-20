import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../repositories/auth_repository.dart';
import './login_event.dart';
import './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = event.email;
    final isEmailValid = _isEmailValid(email);
    emit(
      state.copyWith(
        email: email,
        isFormValid: isEmailValid && _isPasswordValid(state.password),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = event.password;
    final isPasswordValid = _isPasswordValid(password);
    emit(
      state.copyWith(
        password: password,
        isFormValid: isPasswordValid && _isEmailValid(state.email),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await authRepository.login(state.email, state.password);
      emit(state.copyWith(isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }
}
