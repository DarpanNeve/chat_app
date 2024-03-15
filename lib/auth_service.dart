import 'package:chat_app/chat_list.dart';
import 'package:chat_app/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth/login_page.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state while waiting for the auth state to be determined
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const ChatList();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // Trigger the authentication flow

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      showSnackBar(context, "Platform do not support login");
    }
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await GoogleSignIn().signOut();
    }
    if (context.mounted) {
      showSnackBar(context, "User is signed out.");
    }
  }

  createUserWithEmailAndPassword(
    String name,
    String emailAddress,
    String password,
    BuildContext context,
  ) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      FirebaseAuth auth = FirebaseAuth.instance;

      // Update the display name
      await auth.currentUser!.updateDisplayName(name);
      if (context.mounted) {
        await signInWithEmailAndPassword(emailAddress, password, context);
        await addUserDataToFirestore();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  signInWithEmailAndPassword(
      String emailAddress, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code);
    }
  }

  addUserDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(auth.currentUser?.uid).set({
      "name": auth.currentUser!.displayName,
      "email": auth.currentUser!.email,
      "status": "unavailable",
      "uId": auth.currentUser!.uid
    });
  }
}
