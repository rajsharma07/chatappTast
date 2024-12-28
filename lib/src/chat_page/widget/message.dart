import 'package:chatapp/model/message_model.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.m, required this.isMe});
  final MessageModel m;
  final bool isMe;
  void showEditBox(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) {
        final ctl = TextEditingController(text: m.message);
        return AlertDialog(
          content: TextField(
            controller: ctl,
            decoration: const InputDecoration(
              label: Text("Edit Message:"),
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  if (ctl.text != m.message) {
                    await m.edit(ctl.text);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Save")),
            ElevatedButton(
                onPressed: () async {
                  await m.remove();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: !isMe
          ? null
          : () {
              showEditBox(context);
            },
      title: Text(m.message),
      subtitle: Row(
        children: [
          Text(isMe ? "you" : m.sender),
          const Spacer(),
          Text(m.timeStamp.toString()),
        ],
      ),
    );
  }
}
