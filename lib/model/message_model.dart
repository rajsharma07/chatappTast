import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String reciever;
  final DateTime timeStamp;
  final String message;
  MessageModel(
      {required this.message,
      required this.reciever,
      required this.sender,
      required this.timeStamp});
  Future<void> send() async {
    final l = [reciever, sender];
    l.sort();
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(l[0] + l[1])
        .collection("chats")
        .add({
      "message": message,
      "reciever": reciever,
      "sender": sender,
      "timeStamp": timeStamp
    });
  }

  Future<void> remove() async {
    final l = [reciever, sender];
    l.sort();
    final d = await FirebaseFirestore.instance
        .collection("messages")
        .doc(l[0] + l[1])
        .collection("chats")
        .where("sender", isEqualTo: sender)
        .where("reciever", isEqualTo: reciever)
        .where("timeStamp", isEqualTo: Timestamp.fromDate(timeStamp))
        .get();
    for (var i in d.docs) {
      await i.reference.delete();
    }
  }

  Future<void> edit(String newMessage) async {
    final l = [reciever, sender];
    l.sort();
    final d = await FirebaseFirestore.instance
        .collection("messages")
        .doc(l[0] + l[1])
        .collection("chats")
        .where("sender", isEqualTo: sender)
        .where("reciever", isEqualTo: reciever)
        .where("timeStamp", isEqualTo: Timestamp.fromDate(timeStamp))
        .get();
    if (d.docs.isNotEmpty) {
      d.docs[0].reference.update({"message": newMessage});
    }
  }
}
