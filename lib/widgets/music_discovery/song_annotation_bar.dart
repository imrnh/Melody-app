import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getSongAnnotationBar(dynamic context, String annotation) {
  var displayWidth = MediaQuery.of(context).size.width;
  var containerWidth = displayWidth - (20 * 2);

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: containerWidth,
              height: 1,
              color: const Color.fromRGBO(238, 238, 238, 1),
            ),

            SizedBox(
              width: containerWidth,
              child: Text("${annotation.substring(0, 129)}... more",
                style: GoogleFonts.inter(
                  fontSize: 9
                ),
              ),
            ),

            Container(
              width: containerWidth,
              height: 1,
              color: const Color.fromRGBO(238, 238, 238, 1),
            ),
          ],
        ),
      ));
}
