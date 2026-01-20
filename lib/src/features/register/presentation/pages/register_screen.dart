import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';
import '../../../../../repositories/auth_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context.read<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User registered successfully')),
              );
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 48),
                _NameField(),
                SizedBox(height: 16),
                _UsernameField(),
                SizedBox(height: 16),
                _EmailField(),
                SizedBox(height: 16),
                _PasswordField(),
                SizedBox(height: 24),
                _RegisterButton(),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Already have account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (name) =>
              context.read<RegisterBloc>().add(NameChanged(name)),
          decoration: InputDecoration(
            labelText: 'Full Name',
            errorText: state.name.isEmpty ? 'Name is required' : null,
          ),
        );
      },
    );
  }
}

class _UsernameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (username) =>
              context.read<RegisterBloc>().add(UsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'Username',
            errorText: state.username.isEmpty || state.username.length < 3
                ? 'Username must be 3+ chars'
                : null,
          ),
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) =>
              context.read<RegisterBloc>().add(EmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.isEmpty || !_isEmailValid(state.email)
                ? 'Valid email required'
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
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (password) =>
              context.read<RegisterBloc>().add(PasswordChanged(password)),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.length < 6
                ? 'Password must be 6+ chars'
                : null,
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isFormValid && !state.isSubmitting
              ? () => context.read<RegisterBloc>().add(RegisterSubmitted())
              : null,
          child: state.isSubmitting
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Register'),
        );
      },
    );
  }
}
