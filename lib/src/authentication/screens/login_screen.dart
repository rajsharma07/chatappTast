import 'package:chatapp/src/authentication/bloc/auth_bloc.dart';
import 'package:chatapp/src/authentication/bloc/auth_event.dart';
import 'package:chatapp/src/authentication/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void login() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      context.read<AuthBloc>().add(Login(
            email: email,
            password: password,
          ));
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (context.read<AuthBloc>().state.status == AuthStatus.error) {
          showMessage(context.read<AuthBloc>().state.message);
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Enter Email: "),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim() == "" ||
                      !emailRegex.hasMatch(value)) {
                    return "Enter valid Email address";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  email = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Password: "),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim() == "" ||
                      value.length <= 6) {
                    return "Password should have minimum length of 6 characters";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  password = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed:
                    context.read<AuthBloc>().state.status == AuthStatus.loading
                        ? null
                        : () {
                            login();
                          },
                child:
                    context.read<AuthBloc>().state.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(ChangeScreen(1));
                  },
                  child: const Text("New user? click here to Register"))
            ],
          )),
    );
  }
}
