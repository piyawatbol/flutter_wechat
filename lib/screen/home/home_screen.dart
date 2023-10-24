import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/widget/auto_text.dart';
import 'package:we_chat/widget/chat_user_card.dart';
import '../widget/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> chatList = [];

  getData() async {
    await APIs.getSelfInfo();
  }

  @override
  void initState() {
    super.initState();
    getData();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message.toString());
      print('hello');
      if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
      if (message.toString().contains('pause')) APIs.updateActiveStatus(false);
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: AutoText("We Chat"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/profile');
            },
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(APIs.me.image.toString()),
                )),
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                // List dataList = [];
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    chatList = data
                            ?.map((e) => ChatUserModel.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (chatList.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: chatList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChatUserCard(
                              chatList: chatList[index],
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: AutoText("Not found message"));
                    }
                }
                // if (snapshot.hasData) {
                //   final data = snapshot.data?.docs;
                //   for (var i in data) {
                //     dataList.add(i.data());
                //   }
                //   chatList.clear();
                //   chatList.addAll(dataList.map<ChatUserModel>(
                //       (values) => ChatUserModel.fromJson(values)));
                // }
                // return Expanded(
                //   child: ListView.builder(
                //     itemCount: dataList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return ChatUserCard(
                //         chatList: chatList[index],
                //       );
                //     },
                //   ),
                // );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.toNamed('add_friend');
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
