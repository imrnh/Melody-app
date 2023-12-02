import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:twilite/pages/history_view.dart';
import 'package:twilite/pages/music_discovery/discovered_music_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

  final String root_url = "https://advanced-sheepdog-awaited.ngrok-free.app/";

  TextEditingController editingController = TextEditingController();
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
    String url = root_url + 'lyrics/search';
    String textToSend = editingController.text;
    try {
      String? user_id = FirebaseAuth.instance.currentUser?.uid;
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'search_text': textToSend, 'user_id': user_id}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var responseData = await response.body;

      List<dynamic> songs = json.decode(responseData)['songs'];
      if (songs.length > 0) {
        Get.to(DiscoveredMusicViewPage(songs: songs));
      }
    } catch (e) {
      print("Exception : $e");
    }
  }

  void uploadFile() async {
    final String api_url = "${root_url}audio/identify/";
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$audioFilename.m4a');
    String? user_id = FirebaseAuth.instance.currentUser?.uid;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(api_url),
    );

    request.fields['user_id'] = user_id!;

    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: file.path.split('/').last);

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print("\n\n\n@@@ RESPONSE IS: ${json.decode(responseData)}");

      List<dynamic> songs = json.decode(responseData)['songs'];
      Get.to(DiscoveredMusicViewPage(songs: songs));
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

  Future<void> fetchUserHistory(String userId) async {
    final url = '${root_url}audio/view_history/';

    print("@@REQUEST URL: ${url}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      final responseData = jsonDecode(response.body);

      List<dynamic> fetchedSongs = [];
      if(responseData != null){
        print("RESPONSE: ${responseData['songs']}");
        fetchedSongs = responseData['songs'];
      }
      Get.to(()=>HistoryViewPage(userHistory: fetchedSongs));
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(220, 225, 223, 1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Hi!, ",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700)),
                              )),
                          Text(
                            "${FirebaseAuth.instance.currentUser!.displayName?.substring(0, 10)!}",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w400)),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.logout,
                            color: Colors.brown,
                            size: 17,
                          ),
                          label: Text(""),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(220, 225, 223, 1)),
                            elevation: MaterialStateProperty.all(0),
                          ),
                        ),
                      ))
                ],
              ),

              SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => fetchUserHistory(
                        FirebaseAuth.instance.currentUser!.uid),
                    icon: Icon(
                      Icons.queue_music_outlined,
                      color: Colors.black,
                    ),
                    label: Text(
                      "Library",
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(230, 235, 233, 1))),
                  ),
                  SizedBox(height: 100),
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 200 +
                              _controller.value * (!isRecording ? 5.0 : 30.0),
                          height: 200 +
                              _controller.value * (!isRecording ? 5.0 : 30.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(20, 18, 18, 1)),
                                elevation: MaterialStateProperty.all(0.0),
                              ),
                              onPressed: toggleRecording,
                              child: isRecording
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  color: Colors.white
                                                      .withOpacity(1),
                                                  fontSize: 15 +
                                                      _controller.value * 5.0,
                                                  fontWeight: FontWeight.w300)),
                                        )
                                      ],
                                    )
                                  : Image(
                                      image: AssetImage(
                                          "assets/icons/microphone.png"),
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
                    height: 70,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 55,
                    child: TextFormField(
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(color: Colors.black)),
                      controller: editingController,
                      decoration: InputDecoration(
                          hintText: "Search with lyrics instead",
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
            ],
          ),
        ),
      ),
    ));
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
