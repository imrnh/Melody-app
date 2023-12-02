import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twilite/pages/music_discovery/listen_audio.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<UserCredential?> signInWithGoogle() async {
    try {
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
      Get.to(()=>ListenMusicPage());
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("@MESSAGE _ ERROR $e");
      return null;
    }
  }

  Future<void> checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already logged in, redirect to ListenMusicPage
      Get.off(() => ListenMusicPage());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkUserLoggedIn();
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
                  left: MediaQuery.of(context).size.width * .33,
                    top: 100,
                    child: Text("Melody",
                        style: GoogleFonts.aBeeZee(textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.brown)))),
                Center(
                  child:  Image(image: AssetImage("assets/images/music-notes.png"), width: 250,),
                ),
                Positioned(
                    bottom: 120,
                    child: SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.brown),
                        ),
                        onPressed: signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.white,),
                        label: const Text("Sign in with Google", style: TextStyle(color: Colors.white),),
                      ),
                    ))
              ],
            ))));
  }
}
