import 'package:chatapp/src/authentication/bloc/auth_event.dart';
import 'package:chatapp/src/authentication/bloc/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    //login business login
    on<Login>(
      (event, emit) async {
        emit(state.copyWith(a: AuthStatus.loading));
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(state.copyWith(a: AuthStatus.successful));
        } on FirebaseAuthException catch (error) {
          emit(state.copyWith(a: AuthStatus.error, message: error.message));
        }
      },
    );

    on<Register>(
      (event, emit) async {
        emit(state.copyWith(a: AuthStatus.loading));
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
          await FirebaseFirestore.instance.collection("users").add({
            "name": event.name,
            "phone": event.phone,
            "email": event.email,
            "uid": FirebaseAuth.instance.currentUser!.uid
          });
        } on FirebaseException catch (error) {
          emit(state.copyWith(a: AuthStatus.error, message: error.message));
        }
      },
    );
    on<ChangeScreen>(
      (event, emit) {
        emit(state.copyWith(cs: event.i));
      },
    );
  }
}
