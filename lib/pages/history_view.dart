import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilite/api/SongsModel.dart';
import 'package:twilite/widgets/music_discovery/possible_similarities_card.dart';

class HistoryViewPage extends StatelessWidget {
  final List<dynamic> userHistory;
  HistoryViewPage({super.key, required this.userHistory});




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "History",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
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
                      userHistory[index][2], //cover
                      userHistory[index][0], //title
                      userHistory[index][1], //artist
                      userHistory[index][3], //playbackurl
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
