import 'package:chatapp_1/Widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(""
          "chat").orderBy("createdAt",descending: true).snapshots(),
      builder: (ctx, snapchot) {
        if (snapchot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapchot.data.docs;
        return ListView.builder(
          reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              return MessageBubbe(
                  docs[index]["text"],
                docs[index]["username"],
                docs[index]["userImage"],
                docs[index]["userId"] == FirebaseAuth.instance.currentUser.uid,
                // key: ValueKey("index"),
                key: ValueKey(docs[index].documentID),
              );
            });
      },
    );
  }
}
