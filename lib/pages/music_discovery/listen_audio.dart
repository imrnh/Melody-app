import 'package:get/get.dart';
import 'package:record/record.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:twilite/pages/music_discovery/discovered_music_view.dart';
import 'package:google_fonts/google_fonts.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ListenMusicPage extends StatefulWidget {
  ListenMusicPage({super.key});

  @override
  State<ListenMusicPage> createState() => _ListenMusicPageState();
}

class _ListenMusicPageState extends State<ListenMusicPage>
    with TickerProviderStateMixin {
  final recorder = AudioRecorder();
  List<dynamic> audioData = [];
  late DateTime startTime;
  late String rpath = "";
  final String audioFilename = randomString();
  bool isRecording = false;

  TextEditingController editingController = TextEditingController();
  String _response = '';

  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat(
        reverse: true); // Reversing the animation to create a continuous effect
    super.initState();
  }

  void searchWithLyrics() async {
    String url = 'http://192.168.65.244:8000/lyrics/search';
    String textToSend = editingController.text;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'search_text': textToSend}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var responseData = await response.body;

      List<dynamic> songs = json.decode(responseData)['songs'];
      if (songs.length > 0) {
        Get.to(DiscoveredMusicViewPage(
            songTitle: songs[0]['mname'],
            songArtist: songs[0]['artist_name'],
            songs: songs));
      }
    } catch (e) {
      print("Exception : $e");
    }
  }

  void uploadFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$audioFilename.m4a');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.24.78.19:8000/music/uploadfile/'),
    );

    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: file.path.split('/').last);

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      List<dynamic> songs = json.decode(responseData)['songs'];

      String first_song = songs[0];
      String title = first_song.split(" - ")[0];
      String artist = first_song.split(" - ")[1];
      Get.to(DiscoveredMusicViewPage(
          songTitle: title, songArtist: artist, songs: songs));
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  void recordOnFile() async {
    if (await recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      startTime = DateTime.now();
      await recorder.start(const RecordConfig(sampleRate: 44100),
          path: '${directory.path}/$audioFilename.m4a');
    }
  }

  void stopRecording() async {
    await recorder.stop();
    uploadFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 23, 1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width:
                          200 + _controller.value * (!isRecording ? 5.0 : 30.0),
                      height:
                          200 + _controller.value * (!isRecording ? 5.0 : 30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(180, 180, 180, 1)),
                            elevation: MaterialStateProperty.all(0.0),
                          ),
                          onPressed: toggleRecording,
                          child: isRecording
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/icons/microphone.png"),
                                      width: 60 +
                                          _controller.value *
                                              (!isRecording ? 5.0 : 15.0),
                                      height: 60 +
                                          _controller.value *
                                              (!isRecording ? 5.0 : 15.0),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tap to stop",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              fontSize:
                                                  15 + _controller.value * 5.0,
                                              fontWeight: FontWeight.w300)),
                                    )
                                  ],
                                )
                              : Image(
                                  image:
                                      AssetImage("assets/icons/microphone.png"),
                                  width: 96 +
                                      _controller.value *
                                          (!isRecording ? 5.0 : 30.0),
                                  height: 96 +
                                      _controller.value *
                                          (!isRecording ? 5.0 : 30.0),
                                )),
                    );
                  }),
              SizedBox(
                height: 100,
              ),
              Text(
                "Search with lyrics instead?",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: editingController,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchWithLyrics();
                        },
                        child: Icon(Icons.search_outlined),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleRecording() {
    setState(() {
      if (isRecording) {
        stopRecording();
      } else {
        recordOnFile();
      }
      isRecording = !isRecording;
    });
  }
}
