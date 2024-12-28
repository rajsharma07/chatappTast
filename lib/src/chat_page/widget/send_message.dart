import 'package:chatapp/model/message_model.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage(
      {super.key,
      required this.sender,
      required this.reciever,
      required this.sctl});
  final String sender;
  final ScrollController sctl;
  final String reciever;
  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final messageController = TextEditingController();
  void send() async {
    if (messageController.text.trim() != "") {
      final m = MessageModel(
          message: messageController.text,
          reciever: widget.reciever,
          sender: widget.sender,
          timeStamp: DateTime.now());
      await m.send();
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          widget.sctl.animateTo(widget.sctl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear);
        },
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          decoration: const InputDecoration(hintText: "Type Message...."),
          controller: messageController,
        )),
        IconButton(
            onPressed: () {
              send();
            },
            icon: const Icon(Icons.send))
      ],
    );
  }
}
