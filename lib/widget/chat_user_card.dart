// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/model/message_model.dart';
import 'package:we_chat/screen/home/chat_screen.dart';
import 'package:we_chat/widget/date_formatter.dart';

import 'auto_text.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUserModel chatList;
  ChatUserCard({required this.chatList});

  MessageModel? message;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: Card(
          child: StreamBuilder(
        stream: APIs.getLastMessage(chatList),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              if (data!.isNotEmpty) {
                final list =
                    data.map((e) => MessageModel.fromJson(e.data())).toList();
                if (list.isNotEmpty) {
                  message = list[0];
                }
                message = MessageModel.fromJson(data.first.data());
              }

              return ListTile(
                onTap: () {
                  Get.to(() => ChatScreen(user: chatList));
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      "${chatList.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: AutoText("${chatList.name}"),
                subtitle: data.isEmpty
                    ? SizedBox()
                    : message!.formId == APIs.me.id
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              message!.type == 'image'
                                  ? AutoText(
                                      "you : send image ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : SizedBox(
                                      width: size.width * 0.5,
                                      child: AutoText(
                                        "you : ${message!.msg}",
                                        overflow: TextOverflow.ellipsis,
                                        minfontSize: 14,
                                        maxLines: 1,
                                      ),
                                    ),
                              message!.read == ''
                                  ? AutoText(
                                      "unread",
                                    )
                                  : AutoText("readed")
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              message!.type == 'image'
                                  ? AutoText(
                                      "send image ",
                                      color: message!.read != ""
                                          ? Colors.grey
                                          : Colors.blue,
                                      maxLines: 1,
                                    )
                                  : AutoText(
                                      "${message!.msg}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      minfontSize: 14,
                                      fontWeight: message!.read == ""
                                          ? FontWeight.w600
                                          : null,
                                      color: message!.read == ""
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                              AutoText(
                                DateFormatter.getFormattedDate(
                                    context: context, time: message!.sent!),
                              )
                            ],
                          ),
                trailing: chatList.isOnline == false
                    ? SizedBox()
                    : Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
              );
          }
        },
      )),
    );
  }
}
