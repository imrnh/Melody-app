import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


Widget playSongButton(BuildContext context, String playUrl, Color bgColor, Color txtColor){

  var displayWidth = MediaQuery.of(context).size.width;



  final Uri _url = Uri.parse(playUrl);

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  return Center(
    child: GestureDetector(
      onTap: _launchUrl,
      child: Container(
        width: displayWidth * 0.6,
        height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Text("Play Song", style:
          GoogleFonts.inter(
            color: txtColor,
            fontSize: 17,
          )),
        )
      ),
    ),
  );
}



Widget miniPlaySongButton(BuildContext context, String playUrl){

  var displayWidth = MediaQuery.of(context).size.width;


  final Uri _url = Uri.parse(playUrl);

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  return Center(
    child: GestureDetector(
      onTap: _launchUrl,
      child: Container(
          width: 70,
          height: 27,
          decoration: BoxDecoration(
              color: Color.fromRGBO(61, 125, 201, 1),
              borderRadius: BorderRadius.circular(25)
          ),
          child: Center(
            child: Text("Play Song", style:
            GoogleFonts.inter(
              color: Colors.white,
              fontSize: 9,
            )),
          )
      ),
    ),
  );
}


