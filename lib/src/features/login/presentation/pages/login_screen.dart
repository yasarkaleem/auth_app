import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../../../register/presentation/pages/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(context.read()),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 48),
                _EmailField(),
                SizedBox(height: 16),
                _PasswordField(),
                SizedBox(height: 24),
                _LoginButton(),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  ),
                  child: Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.read<LoginBloc>().add(EmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.isEmpty
                ? null
                : !_isEmailValid(state.email)
                ? 'Invalid email'
                : null,
          ),
        );
      },
    );
  }

  static bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (password) =>
              context.read<LoginBloc>().add(PasswordChanged(password)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.isEmpty
                ? null
                : state.password.length < 6
                ? 'Password too short'
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isFormValid && !state.isSubmitting
              ? () => context.read<LoginBloc>().add(LoginSubmitted())
              : null,
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text('Login'),
        );
      },
    );
  }
}
