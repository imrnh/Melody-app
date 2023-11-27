import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilite/widgets/music_discovery/play_music_button.dart';

Widget possibleSimilarDiscoveriesCard(BuildContext context, String imgPath,
    String songName, String songArtist, String playUrl) {
  double displayWidth = MediaQuery.of(context).size.width;

  double contentWidth = displayWidth * 0.85;
  double contentHeight = 95.0;

  return Padding(
    padding: const EdgeInsets.fromLTRB(43, 0, 0, 0),
    child: Container(
      width: contentWidth,
      height: contentHeight,
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: contentHeight,
            height: contentHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(imgPath), fit: BoxFit.cover),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      songName.substring(
                          0,
                          songName.length > 22
                              ? 22
                              : songName
                                  .length), //take only first 22 character of the name.
                      style: GoogleFonts.inter(
                        fontSize: 15,
                      )),
                  Text(songArtist,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                      )),
                  const SizedBox(height: 15),
                  miniPlaySongButton(context, playUrl)
                ],
              )),
        ],
      ),
    ),
  );
}
