import 'dart:html';

import 'package:chat_app/auth_service.dart';
import 'package:chat_app/individual_chat.dart';
import 'package:chat_app/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {
  late final AppLifecycleState appLifecycleState;
  final User? _user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> allUsers = [];
  final _search = TextEditingController();
  late String roomId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("started");
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    if (_user!=null) {
      await setStatus("dispose");
    }
    print("dispose is working");

    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    appLifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      await setStatus("resumed");
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await setStatus("paused");
    }
  }
  setStatus(String status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        "status": status,
      },
    );
  }
  String chatRoomId(String? user1, String user2) {
    if (user1!.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  void search() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .where("name", isEqualTo: _search.text)
        .get();
    List<Map<String, dynamic>> foundUsers = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      allUsers = foundUsers;
    });

    print(allUsers);
  }

  void fetchAllUsers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .where("email", isNotEqualTo: _user!.email)
        .get();
    List<Map<String, dynamic>> fetchedUsers = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      allUsers = fetchedUsers;
    });

    print(allUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users List"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                AuthService().signOut(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 25),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _search,
                  decoration: const InputDecoration(hintText: "Search"),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  search();
                },
                child: const Text("Search User"),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  fetchAllUsers();
                },
                child: const Text("Fetch All Users"),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          tileColor: Colors.grey[200],
                          title: Text(
                              "${allUsers[index]["name"]}\n${allUsers[index]["email"]}"),
                          subtitle: Text(allUsers[index]["status"]),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                roomId = chatRoomId(_user?.displayName,
                                    allUsers[index]["name"]);
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => IndividualChat(
                                      roomId: roomId, userMap: allUsers[index]),
                                ),
                              );
                            },
                            child: const Text("Chat"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
