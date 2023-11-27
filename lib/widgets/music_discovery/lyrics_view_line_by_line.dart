import 'package:flutter/material.dart';

Widget plotLyricsLine(List<String> lyricsTextList, String songUUID){
  //use the songUUID and lineID to fetch annotation form the db.

  return ListView.builder(
    itemCount: lyricsTextList.length,
    itemBuilder: (BuildContext context, int index) {
      return Text(
        lyricsTextList[index],
        style: const TextStyle(fontSize: 16.0), // You can customize the style as needed
      );
    },
  );
}