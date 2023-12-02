import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twilite/widgets/music_discovery/cover_image_with_wrapper.dart';
import 'package:twilite/widgets/music_discovery/play_music_button.dart';
import 'package:twilite/widgets/music_discovery/possible_similarities_card.dart';
import 'package:twilite/widgets/music_discovery/song_annotation_bar.dart';
import 'package:twilite/widgets/topbars.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> fetchLyrics(int song_id, Map<String, String> songInfo) async {


    const String apiUrl = 'https://advanced-sheepdog-awaited.ngrok-free.app/lyrics/get_lyrics'; // Replace with your API endpoint
    final Map<String, String> queryParams = {
      'song_id': song_id.toString(),
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      final data = json.decode(response.body);
      print('Response data: $data');
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
  }

  List<dynamic> reognized_songs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      reognized_songs = widget.songs;
  }
  @override
  Widget build(BuildContext context) {

    String playUrl =reognized_songs[0]['playback_url'];
    String cover_image = reognized_songs[0]['cover_image'];

    String songTitle = reognized_songs[0]['mname'];
    String songArtist = reognized_songs[0]['artist_name'];

    Map<String, String> songInfoForLyricsView = {
      'name':  reognized_songs[0]['mname'],
      'artist':  reognized_songs[0]["artist_name"],
      'id':  reognized_songs[0]['id'],
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(

          children: [
            Stack(
              children: [
                getDiscoveredMusicCoverWidget(
                    context, cover_image, songTitle, songArtist),
                getTransparentTopBar(fetchLyrics, reognized_songs[0]['id'] ?? 0, songInfoForLyricsView),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
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
                itemCount: reognized_songs.length - 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      possibleSimilarDiscoveriesCard(
                        context,
                        reognized_songs[index + 1]['cover_image'],
                        reognized_songs[index + 1]['mname'],
                        reognized_songs[index + 1]['artist_name'], reognized_songs[index + 1]['playback_url']
                      ),
                      const SizedBox(height: 30,)
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
