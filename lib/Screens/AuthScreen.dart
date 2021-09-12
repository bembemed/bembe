import 'dart:io';

import 'package:chatapp_1/Widgets/auth/AuthForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _sumbitAuthForm(String email, String password, String username,
      File image,bool isLogin, BuildContext ctx) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (!isLogin) {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance.ref().child("user_image")
            .child(_authResult.user.uid + ".jpg");
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection("users").doc(_authResult.user.uid).
    set({
          "username": username,
          "password": password,
          "image_url" :url,
        });
      } else {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text(""),
      //   backgroundColor: Theme.of(context).errorColor,
      // ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_sumbitAuthForm,_isLoading),
    );
  }
}
