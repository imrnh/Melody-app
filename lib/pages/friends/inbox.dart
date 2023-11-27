import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';





class InboxPage extends StatefulWidget {
  final String OTHER;
  const InboxPage({Key? key, required this.OTHER}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late String _OTHER;
  String? _MYSELF;
  String? _MYNAME = null;
  types.User _user = types.User(id: "");

  final List<types.Message> _messages = [];
  late DatabaseReference reference, reciever_reference;

  @override
  void initState() {
    super.initState();
    _OTHER = widget.OTHER;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _MYSELF = null;
      } else {
        _MYSELF = user.uid;
        _MYNAME = user.displayName;
        _user = types.User(id: _MYSELF!);
        reference =
            FirebaseDatabase.instance.ref('/users/${user.uid}/chats/$_OTHER/');
        reciever_reference =
            FirebaseDatabase.instance.ref('/users/$_OTHER/chats/${user.uid}/');
      }
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    try {
      if (_MYSELF != "") {
        print("@MESSAGE $_MYNAME");
        await reference.push().set(
            {"msg": message.text, "sender": _MYSELF, "sender_name": _MYNAME!});
        await reciever_reference.push().set(
            {"msg": message.text, "sender": _MYSELF, "sender_name": _MYNAME!});
      }
    } catch(e) {
      print("@MESSAGE $e");
    }

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
