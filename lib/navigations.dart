import 'package:get/get.dart';
import 'package:twilite/auth_home.dart';
import 'package:twilite/pages/friends/inbox.dart';
import 'package:twilite/pages/homepage.dart';
import 'package:twilite/pages/music_discovery/listen_audio.dart';

List<GetPage<dynamic>> pageMapping() {
  return [
    GetPage(name: "/auth", page: () => AuthScreen()),
    GetPage(name: "/", page: () => Homepage(title: "Home")),
    GetPage(name: "/inbox", page: () => InboxPage(OTHER: '4356786efrfsdgsdgsdfgdg')),
    GetPage(name: "/discover", page: ()=> ListenMusicPage())
  ];
}
