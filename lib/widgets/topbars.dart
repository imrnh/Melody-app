import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appbar_buttons.dart';


Widget getTransparentTopBar(VoidCallback lyricsViewPressed){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      getAppBarButton(const Icon(Icons.arrow_back_ios_new), ()=>Get.back()),
      getAppBarButtonWithIconAndText(const Icon(Icons.music_note_outlined),"Lyrics", lyricsViewPressed)
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