import 'package:chatapp/src/authentication/bloc/auth_bloc.dart';
import 'package:chatapp/src/authentication/bloc/auth_state.dart';
import 'package:chatapp/src/authentication/screens/login_screen.dart';
import 'package:chatapp/src/authentication/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int current = 0;
  List<Widget> widgetList = [
    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return LoginScreen();
    }),
    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return RegisterScreen();
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return AuthBloc();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return widgetList[state.currentScreen];
          },
        ),
      ),
    );
  }
}
