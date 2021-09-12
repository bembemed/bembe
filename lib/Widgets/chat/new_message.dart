import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async{
    FocusScope.of(context).unfocus();
    //
    final user =   FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance.collection("users").
        doc(user.uid).get();
    // send a Message here
    print("bembe");
    FirebaseFirestore.instance
        .collection("chat").add({
      "text": _enteredMessage,
      "createdAt" : Timestamp.now(),
      "username":  userdata["username"],
      "userId":user.uid,
      "UserImage" : userdata["image_url"],
    });

    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "send a message...",

            ),
            onChanged: (val){
              setState(() {
                _enteredMessage = val;
              });
            },
          )),
          IconButton(
              onPressed: (){
                _enteredMessage.trim().isEmpty? null: _sendMessage();
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
