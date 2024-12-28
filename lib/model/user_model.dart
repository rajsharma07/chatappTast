import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  const UserModel({required this.name, required this.email});
  @override
  List<Object> get props => [name, email];
}
