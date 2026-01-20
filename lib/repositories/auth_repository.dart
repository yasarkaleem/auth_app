import '../models/user.dart';
import '../services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');
    if (userId != null) {
      return await _databaseService.getUserById(userId);
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    final dbUser = await _databaseService.getUser(email);
    if (dbUser == null || dbUser.password != password) {
      throw Exception('Invalid email or password');
    }

    // Store current user ID
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', dbUser.id!);
  }

  Future<User> register(String name, String username, String email, String password) async {
    final existingUser = await _databaseService.getUser(email);
    if (existingUser != null) {
      throw Exception('Email already exists');
    }

    final user = User(
      name: name,
      username: username,
      email: email,
      password: password,
    );
    final id = await _databaseService.insertUser(user.toMap());

    // Store current user ID after registration
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
  }
}
