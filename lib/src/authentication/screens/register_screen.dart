import 'package:chatapp/src/authentication/bloc/auth_bloc.dart';
import 'package:chatapp/src/authentication/bloc/auth_event.dart';
import 'package:chatapp/src/authentication/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void register() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<AuthBloc>().add(Register(
            name: name,
            phone: phoneNumber,
            email: email,
            password: password,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Register",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Name: "),
                ),
                validator: (value) {
                  if (value == null || value.trim() == "") {
                    return "Enter valid username";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  name = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Phone number: "),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim() == "" ||
                      !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Enter valid Phone number";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  phoneNumber = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
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
                            register();
                          },
                child:
                    context.read<AuthBloc>().state.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text("Register"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(ChangeScreen(0));
                  },
                  child: const Text(
                      "Already have an account? \nclick here to Login"))
            ],
          )),
    );
  }
}
