import 'package:equatable/equatable.dart';

enum AuthStatus { initial, error, successful, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final int currentScreen;
  final String message;
  const AuthState(
      {this.status = AuthStatus.initial,
      this.currentScreen = 0,
      this.message = ""});
  AuthState copyWith({AuthStatus? a, int? cs, String? message}) {
    return AuthState(
        status: a ?? status,
        currentScreen: cs ?? currentScreen,
        message: message ?? "");
  }

  @override
  List<Object> get props => [status, currentScreen];
}
