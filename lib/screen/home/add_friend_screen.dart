import 'package:flutter/material.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/screen/widget/colors.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            children: [
              TextField(
                controller: email,
              ),
              ElevatedButton(
                  onPressed: () {
                    APIs.addChatUser(email.text);
                  },
                  child: Text("add"))
            ],
          ),
        ),
      ),
    );
  }
}
