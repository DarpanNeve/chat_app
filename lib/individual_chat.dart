import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IndividualChat extends StatelessWidget {
  final String roomId;

  IndividualChat({super.key, required this.roomId, required this.userMap});

  final Map<String, dynamic> userMap;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_message.text.isNotEmpty) {
      await _fireStore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .add(
        {
          "sendBy": _auth.currentUser!.displayName,
          "message": _message.text,
          "time": FieldValue.serverTimestamp(),
        },
      );
      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['name']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection('chatroom')
            .doc(roomId)
            .collection('chats')
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data!.docs[index].data() == null) {
                  return Container();
                }
                return GestureDetector(
                  child: Container(
                    width: 300,
                    alignment: snapshot.data!.docs[index]["sendBy"] ==
                            _auth.currentUser!.displayName
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.docs[index]['sendBy'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data!.docs[index]['message'],
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      sendMessage();
                    },
                    controller: _message,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
