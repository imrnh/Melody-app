import 'package:flutter/material.dart';

Widget getAppBarButton(Icon icon, dynamic onPressedFunction) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      onPressed: onPressedFunction,
      child: icon);
}


Widget getAppBarButtonWithIconAndText(Icon icon, String text, VoidCallback onPressedEvent){
  return ElevatedButton(onPressed: onPressedEvent,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    child: SizedBox(
      child: Row(
        children: [
          icon,
          const SizedBox(width: 7),
          Text(text.toString())
        ],
      ),
    ),
  );
}