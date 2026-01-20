import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/shared/bloc/auth/auth_bloc.dart';
import 'src/shared/bloc/auth/auth_event.dart';
import 'src/shared/bloc/auth/auth_state.dart';
import 'repositories/auth_repository.dart';
import 'src/features/login/presentation/pages/login_screen.dart';
import 'src/features/home/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository())..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Auth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AppRouter(),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is AuthAuthenticated) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}
