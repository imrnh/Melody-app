import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getDiscoveredMusicCoverWidget(
    dynamic context, String imagePath, String songTitle, String songArtist) {
  //image_path = assets/images/cover.jpg

  dynamic contentWidth = MediaQuery.of(context).size.width;
  dynamic contentHeight = MediaQuery.of(context).size.height * 0.7;

  return SizedBox(
    width: contentWidth,
    height: contentHeight,
    child: Stack(
      children: [
        Image.asset(
          imagePath,
          width: contentWidth,
          height: contentHeight,
          alignment: Alignment.topCenter,
        ),
        Container(
          width: contentWidth,
          height: contentHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.1),
                Colors.white,
              ],
              begin: Alignment.topCenter, // Start from the top center
              end: Alignment.bottomCenter, // End at the bottom center
              stops: [0.0, 0.9], // Set stops for the gradient colors
            ),
          ),
        ),
        Positioned(
            bottom: 65,
            left: 20,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(songTitle,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
            )),
        Positioned(
            left: 20,
            bottom: 35,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                songArtist,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ))
      ],
    ),
  );
}
