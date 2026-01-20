import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String name;
  final String username;
  final String email;
  final String password;

  const User({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  List<Object?> get props => [id, name, username, email];
}
