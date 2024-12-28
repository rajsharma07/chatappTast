import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchCtl = TextEditingController();

  Set<UserModel> show = {};
  void searchUser() async {
    show.clear();
    if (searchCtl.text.trim() != "") {
      var n = await FirebaseFirestore.instance
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: searchCtl.text)
          .where("name", isLessThan: '${searchCtl.text}\uf8ff')
          .get();
      var emails = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isGreaterThanOrEqualTo: searchCtl.text)
          .where("email", isLessThan: '${searchCtl.text}\uf8ff')
          .get();
      setState(() {
        for (var element in n.docs) {
          show.add(UserModel(
              name: element.data()["name"], email: element.data()["email"]));
        }
        for (var e in emails.docs) {
          show.add(UserModel(name: e["name"], email: e["email"]));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            searchUser();
          },
          controller: searchCtl,
          decoration: const InputDecoration(hintText: "Search..."),
        ),
      ),
      body: ListView.builder(
        itemCount: show.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(show.elementAt(index).name),
            subtitle: Text(show.elementAt(index).email),
          );
        },
      ),
    );
  }
}
