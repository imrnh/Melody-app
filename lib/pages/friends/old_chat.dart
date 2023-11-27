import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final String myUID, frUID;
  const ChatPage({super.key, required this.myUID, required this.frUID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String frUID;
  late List<dynamic> chats;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frUID = widget.frUID;
    fetchFriendInfo();
    fetchFriendChats();
  }

  void fetchFriendInfo() async {
    //fetch image, name and other info.
  }

  void fetchFriendChats() async {
    //fetch all the chat with this user.
    chats = [
      {'sender': 'me', 'message': "Hey! What's up?"},
      {'sender': 'fr', 'message': "Fine. What are you listening now?"},
      {'sender': 'me', 'message': "A new playlist of swift just released."},
      {'sender': 'fr', 'message': "Really?"},
      {
        'sender': 'me',
        'message': "Why would I lie to you? Do I even know you?"
      },
      {'sender': 'fr', 'message': "Seems legitimate"},
    ];
  }

  @override
  Widget build(BuildContext context) {

    double topBarHeight = 70;
    double messageInputfieldHeight = 70;
    double chatViewContainerHeight = MediaQuery.of(context).size.height - (topBarHeight + messageInputfieldHeight + 60); //60 is extra paddings.
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 0.1, // Spread radius
                    blurRadius: 0.4, // Blur radius
                    offset:
                        const Offset(0, 1), // Offset in the x and y directions
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new),
                    Center(
                      child: Row(
                        children: [
                          //user image.
                          //user name,
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            /*
            * chat
            *
            * */
            SizedBox(height: 30),
            chatView(chats, chatViewContainerHeight),
          ],
        ),
      ),
    ));
  }
}



/*
* chatview widget -> move to widgets directory.
*
* */
Widget chatView(List<dynamic> chats, double containerHeight) {
  return Container(
    height: containerHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chats.map((line) {
        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: line['sender'] == 'me'
                      ? const Color.fromRGBO(250, 250, 250, 0.8)
                      : Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    line['message'],
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ));
      }).toList(),
    ),
  );
}



/*
* chat input field. height -> 70
*
* */