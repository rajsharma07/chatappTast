import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/src/chat_page/chat_page.dart';
import 'package:chatapp/src/chats.dart/search.dart';
import 'package:chatapp/src/screens/waiting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({super.key, required this.uid});
  final String uid;
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late UserModel currentUser;
  bool _isLoading = true;
  void getUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final data = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.uid)
        .get();
    if (data.docs.isNotEmpty) {
      Map<String, dynamic> d = data.docs[0].data();
      currentUser = UserModel(name: d["name"], email: d["email"]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat APP"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const Search();
                    },
                  ));
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const WaitingScreen();
                  } else if (!snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No data found"),
                    );
                  }
                  return ListView(
                    children: snapshot.data!.docs.map(
                      (document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(data["name"]),
                          subtitle: Text(data["email"]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(
                                    uid: widget.uid,
                                    currentUser: currentUser,
                                    reciever: UserModel(
                                        name: data["name"],
                                        email: data["email"]));
                              },
                            ));
                          },
                        );
                      },
                    ).toList(),
                  );
                },
              ));
  }
}
