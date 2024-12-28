import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final String email;
  final String password;
  Login({required this.email, required this.password});
}

class Register extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  Register(
      {required this.name,
      required this.phone,
      required this.email,
      required this.password});
}

class ChangeScreen extends AuthEvent {
  final int i;
  ChangeScreen(this.i);
}
