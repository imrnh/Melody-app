import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twilite/api/sample_lyrics.dart';
import 'package:twilite/auth_home.dart';
import 'package:twilite/navigations.dart';
import 'package:twilite/pages/friends/old_chat.dart';
import 'package:twilite/pages/homepage.dart';
import 'package:twilite/pages/music_discovery/discovered_music_view.dart';
import 'package:twilite/pages/music_discovery/listen_audio.dart';
import 'package:twilite/pages/music_discovery/lyrics_view.dart';
import 'package:twilite/widgets/appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String appName = "Twilite";

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('@MESSAGE ___ User is currently signed out!');
      } else {
        print('@MESSAGE ___ User is signed in! ${user.displayName}');
      }
    });
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/discover", //ChatPage(myUID: "2343", frUID: "4009viodsf"),
      getPages: pageMapping(),
    );
  }
}

// LyricsViewPage(
// songName: "Rhythm Inside",
// songArtist: "Calum Scott",
// lyricsText: sampleLyrics(),
// songUUID: "192032",
// gradientBeingColor: const Color.fromRGBO(162, 128, 114, .56),
// gradientEndColor: const Color.fromRGBO(184, 159, 149, 0.41)),
