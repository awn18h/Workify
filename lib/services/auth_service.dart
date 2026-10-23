import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  String mas;
  AuthException({required this.mas});
}

class AuthService {
  static Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final userInGoogle = await GoogleSignIn.instance.authenticate();
    final googleAuth = await userInGoogle.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    User? user = userCredential.user;
    final String role = (user!.email ?? '').toLowerCase().endsWith('@admin.com')
        ? 'admin'
        : 'user';
    FirebaseFirestore.instance
        .collection('usersCollection')
        .doc(user.uid)
        .set({'email': userCredential.user!.email, 'role': role})
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Added Successfully')),
          ),
        )
        .catchError((error) => print("Failed to add user: $error"));

    return userCredential;
  }

  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw AuthException(mas: 'invalid verification');
      }
      if (e.code == 'invalid-email.') {
        throw AuthException(mas: 'invalid email');
      } else if (e.code == 'invalid-credential') {
        throw AuthException(mas: 'invalid credential');
      }
      throw AuthException(mas: e.message ?? e.code);
    }
  }

  static Future<UserCredential> signUp({
    required String email,
    required String password,
    String ? displayName,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          await credential.user?.updateDisplayName(displayName);
      FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'email': email.trim(),
            
          });

      return credential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          throw AuthException(mas: 'invalid verification');

        case 'invalid-email':
          throw AuthException(mas: 'invalid email');

        case 'email-already-in-use':
          throw AuthException(mas: 'email already exist');

        case 'network-request-failed':
          throw AuthException(mas: 'network request field');

        case 'weak-password':
          throw AuthException(mas: 'weak password');

        default:
          throw AuthException(mas: 'something wrong');
      }
    }
  }

  static void signout() async {
    FirebaseAuth.instance.signOut();
  }




  static Stream<User?>authState(){
    return FirebaseAuth.instance.userChanges();
  }


  static Future<void> resendPassword(String email){
    try{
      return FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    }on FirebaseAuthException catch(e){
      switch(e){
        case 'invalid-email':
        throw AuthException(mas: 'invalid email');

        default:
        throw AuthException(mas: e.code);
      }
    }
  }


  static Future<void>updateDisplayName(String name)async{
    try{
      final user=FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(name);
    }
    on FirebaseAuthException catch(e){
      throw AuthException(mas: e.code);
    }
  }
}
