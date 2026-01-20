import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../repositories/auth_repository.dart';
import './register_event.dart';
import './register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc(this.authRepository) : super(const RegisterState()) {
    on<NameChanged>(_onNameChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        isFormValid: _isFormValid(
          event.name,
          state.username,
          state.email,
          state.password,
        ),
      ),
    );
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        username: event.username,
        isFormValid: _isFormValid(
          state.name,
          event.username,
          state.email,
          state.password,
        ),
      ),
    );
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isFormValid: _isFormValid(
          state.name,
          state.username,
          event.email,
          state.password,
        ),
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isFormValid: _isFormValid(
          state.name,
          state.username,
          state.email,
          event.password,
        ),
      ),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await authRepository.register(
        state.name,
        state.username,
        state.email,
        state.password,
      );
      emit(state.copyWith(isSubmitting: false, isSuccess:  true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  bool _isFormValid(
    String name,
    String username,
    String email,
    String password,
  ) {
    return name.isNotEmpty &&
        username.length >= 3 &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email) &&
        password.length >= 6;
  }
}
