import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilite/api/sample_lyrics.dart';
import 'package:twilite/widgets/music_discovery/cover_image_with_wrapper.dart';
import 'package:twilite/widgets/music_discovery/lyrics_view_line_by_line.dart';
import 'package:twilite/widgets/music_discovery/play_music_button.dart';
import 'package:twilite/widgets/music_discovery/possible_similarities_card.dart';
import 'package:twilite/widgets/music_discovery/song_annotation_bar.dart';
import 'package:twilite/widgets/topbars.dart';

class LyricsViewPage extends StatefulWidget {
  final Color gradientBeingColor;
  final Color gradientEndColor;
  final String songName, songArtist, lyricsText, songUUID;

  const LyricsViewPage(
      {super.key,
      required this.songName,
      required this.songArtist,
      required this.lyricsText,
      required this.songUUID,
      required this.gradientBeingColor,
      required this.gradientEndColor});

  @override
  State<LyricsViewPage> createState() => _LyricsViewPageState();
}

class _LyricsViewPageState extends State<LyricsViewPage> {
  List<String> lyricsTextArray = [];
  final double perLineLyricsHeight = 25; //found iteratively.
  int lineIdexTracker = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lyricsTextArray = widget.lyricsText.split('\n');
    lineIdexTracker = 0;
  }

  void annotationWindowLaunch(int lineIndex) {
    print("-----------Trying annotation for $lineIndex");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [widget.gradientBeingColor, widget.gradientEndColor],
          begin: Alignment.topCenter, // Start from the top center
          end: Alignment.bottomCenter, // End at the bottom center
          stops: const [0.0, 0.9],
        )),
        child: ListView(
          children: [
            getTransparentTopBarWithBackButtonOnly(),

            /*
            *
            * Song name and the artist's name.
            *
            * */

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(widget.songName,
                  style: GoogleFonts.inter(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  widget.songArtist,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - (2 * 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lyricsTextArray.map((line) {
                      lineIdexTracker++;
                      return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () =>
                                annotationWindowLaunch(lineIdexTracker),
                            child: Text(
                              line,
                              style: GoogleFonts.inter(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ));
                    }).toList(),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 50),
              child: Text("Lyrics Provided by MusixMatch"),
            ),
          ],
        ),
      ),
    ));
  }
}
