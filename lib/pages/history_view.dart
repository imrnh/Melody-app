import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Melody/api/SongsModel.dart';
import 'package:Melody/widgets/music_discovery/possible_similarities_card.dart';

class HistoryViewPage extends StatelessWidget {
  final List<dynamic> userHistory;
  HistoryViewPage({super.key, required this.userHistory});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Library",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: userHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: possibleSimilarDiscoveriesCard(
                      context,
                      userHistory[index]['cover_image'], //cover
                      userHistory[index]['mname'], //title
                      userHistory[index]['artist_name'], //artist
                      userHistory[index]['playback_url'], //playbackurl
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
