import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilite/widgets/music_discovery/cover_image_with_wrapper.dart';
import 'package:twilite/widgets/music_discovery/play_music_button.dart';
import 'package:twilite/widgets/music_discovery/possible_similarities_card.dart';
import 'package:twilite/widgets/music_discovery/song_annotation_bar.dart';
import 'package:twilite/widgets/topbars.dart';

class DiscoveredMusicViewPage extends StatefulWidget {
  final List<dynamic> songs;
  const DiscoveredMusicViewPage({super.key, required this.songs});

  @override
  State<DiscoveredMusicViewPage> createState() =>
      _DiscoveredMusicViewPageState();
}

class _DiscoveredMusicViewPageState extends State<DiscoveredMusicViewPage> {
  void lyricsViewPressed() {
    print("Do something to change the screen to view the lyrics.");
  }

  String songTitle = "";
  String songArtist = "";
  List<dynamic> reognized_songs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      reognized_songs = widget.songs;
  }
  @override
  Widget build(BuildContext context) {

    String songAnnotation = "";
    String playUrl =reognized_songs[0]['playback_url'];
    String cover_image = reognized_songs[0]['cover_image'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(

          children: [
            Stack(
              children: [
                getDiscoveredMusicCoverWidget(
                    context, cover_image, songTitle, songArtist),
                getTransparentTopBar(lyricsViewPressed),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            getSongAnnotationBar(context, songAnnotation),
            const SizedBox(height: 70),
            playSongButton(
                context,
                playUrl,
                const Color.fromRGBO(162, 128, 114, 1),
                const Color.fromRGBO(255, 255, 255, 1)),
            const SizedBox(
              height: 130,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("Possible Similarities",
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ))),
            const SizedBox(
              height: 50,
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: reognized_songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      possibleSimilarDiscoveriesCard(
                        context,
                        reognized_songs[index + 1]['cover_image'],
                        reognized_songs[index + 1]['mname'],
                        reognized_songs[index + 1]['artist_name'], reognized_songs[index + 1]['playback_url']
                      ),
                    ],
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
