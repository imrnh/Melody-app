import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appbar_buttons.dart';


Widget getTransparentTopBar(Function(int, Map<String, String>) lyricsViewPressed, int song_id, Map<String, String> songInfo){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      getAppBarButton(const Icon(Icons.arrow_back_ios_new), ()=>Get.back()),
      getAppBarButtonWithIconAndText(const Icon(Icons.music_note_outlined),"Lyrics", ()=>lyricsViewPressed(song_id, songInfo))
    ],
  );
}


Widget getTransparentTopBarWithBackButtonOnly(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      getAppBarButton(const Icon(Icons.arrow_back_ios_new), ()=>Get.back()),
    ],
  );
}