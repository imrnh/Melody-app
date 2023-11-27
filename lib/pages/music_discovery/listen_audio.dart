import 'package:get/get.dart';
import 'package:record/record.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:twilite/pages/music_discovery/discovered_music_view.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ListenMusicPage extends StatefulWidget {
  const ListenMusicPage({super.key});

  @override
  State<ListenMusicPage> createState() => _ListenMusicPageState();
}

class _ListenMusicPageState extends State<ListenMusicPage> {
  final recorder = AudioRecorder();
  List<dynamic> audioData = [];
  late DateTime startTime;
  late double totalWTime = 0.0;
  late String rpath = "";
  final String audio_filename = randomString();
  bool isRecording = false;

  void uploadFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$audio_filename.m4a');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.24.78.19:8000/uploadfile/'),
    );

    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: file.path.split('/').last);

    request.files.add(multipartFile);

    try {
      // Send the request
      var response = await request.send();

      // Check the response

      var responseData = await response.stream.bytesToString();

      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\t\t\t");
      List<dynamic> songs = json.decode(responseData)['songs'];

      String first_song = songs[0];
      String title = first_song.split(" - ")[0];
      String artist = first_song.split(" - ")[1];
      Get.to(DiscoveredMusicViewPage(
          songTitle: title, songArtist: artist, songs: songs));
    } catch (e) {
      totalWTime = DateTime.now().difference(startTime).inMilliseconds / 1000.0;
      print('Error uploading file: $e');
    }
  }

  void recordOnFile() async {
    if (await recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      startTime = DateTime.now();
      await recorder.start(const RecordConfig(sampleRate: 44100),
          path: '${directory.path}/$audio_filename.m4a');
    }
  }

  // void startListening() async {
  //   audioData = []; //cleanign list before starting.
  //   startTime = DateTime.now();
  //   if (await recorder.hasPermission()) {
  //     final stream = await recorder
  //         .startStream(const RecordConfig(sampleRate: 44100, bitRate: 350000));
  //
  //     stream.listen((data) {
  //       audioData.add(data);
  //     });
  //   }
  // }

  void stopRecording() async {
    final path = await recorder.stop();

    setState(() {
      // rpath = path!;
      totalWTime = DateTime.now().difference(startTime).inMilliseconds / 1000.0;
    });
    uploadFile();
  }

  void printData() {
    // print("\n\n\n\n\n\n\n\n\n\n\n\n\n\naudio data is: \n\n\n\n\n\n\n\n ${audioData[2].length}");
    print("Total length:  ${audioData.length}");
    int lsum = 0;
    audioData.forEach((element) {
      print("L: ${element.length}");
      lsum = lsum + element.length as int;
    });
    print("Bits: $lsum");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amberAccent, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Recorded for ${totalWTime} seconds",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: ElevatedButton(
                  onPressed: toggleRecording,
                  child:
                      Text(isRecording ? "Stop Recording" : "Start Recording"),
                ),
              ),
              SizedBox(height: 50.0),
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
