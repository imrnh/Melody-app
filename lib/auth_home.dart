import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<UserCredential?> signInWithGoogle() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch(e){
      print("@MESSAGE _ ERROR $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.brown, Colors.white],
              stops: [0.5, 1],
              transform: GradientRotation(90 / 180 * 3.1416),
            )),
            child: Scaffold(
                body: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    bottom: 100,
                    child: SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata_rounded),
                        label: const Text("Sign in with Google"),
                      ),
                    ))
              ],
            ))));
  }
}