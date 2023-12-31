import 'package:flutter/material.dart';
import 'package:Melody/widgets/appbar_buttons.dart';

AppBar getAppBar(dynamic context, String title) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(title),
  );
}
