import 'package:chatapp/model/message_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/src/chat_page/widget/message.dart';
import 'package:chatapp/src/chat_page/widget/send_message.dart';
import 'package:chatapp/src/screens/waiting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.currentUser,
      required this.reciever,
      required this.uid});
  final UserModel currentUser;
  final UserModel reciever;
  final String uid;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String chatId = "";
  final _scrollctl = ScrollController();
  void initializeChat() {
    List<String> l = [widget.currentUser.email, widget.reciever.email];
    l.sort();
    chatId = l[0] + l[1];
  }

  @override
  void initState() {
    initializeChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciever.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(chatId)
                  .collection("chats")
                  .orderBy(
                    "timeStamp",
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(child: WaitingScreen());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No chat found"),
                  );
                }
                return Expanded(
                  child: ListView(
                    controller: _scrollctl,
                    children: snapshot.data!.docs.map(
                      (e) {
                        Map<String, dynamic> data =
                            e.data() as Map<String, dynamic>;
                        return Card(
                          color: Colors.cyan[50],
                          child: Message(
                              m: MessageModel(
                                  message: data["message"],
                                  reciever:
                                      data["reciever"] == widget.reciever.email
                                          ? widget.reciever.email
                                          : widget.currentUser.email,
                                  sender:
                                      data["sender"] == widget.reciever.email
                                          ? widget.reciever.email
                                          : widget.currentUser.email,
                                  timeStamp: data["timeStamp"].toDate()),
                              isMe: data["sender"] == widget.currentUser.email),
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ),
            SendMessage(
              sender: widget.currentUser.email,
              reciever: widget.reciever.email,
              sctl: _scrollctl,
            )
          ],
        ),
      ),
    );
  }
}
