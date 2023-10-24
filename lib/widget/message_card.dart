import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/model/message_model.dart';
import 'package:we_chat/screen/widget/colors.dart';
import 'package:we_chat/widget/auto_text.dart';
import 'package:we_chat/widget/big_image.dart';
import 'package:we_chat/widget/date_formatter.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final ChatUserModel user;
  const MessageCard({required this.message, required this.user});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.formId
        ? buildMyselfMessages()
        : buildOtherMessages();
  }

  Widget buildOtherMessages() {
    var size = MediaQuery.of(context).size;
    if (widget.message.read!.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }
    return Row(
      children: [
        SizedBox(width: 15),
        CircleAvatar(
          radius: size.width * 0.04,
          backgroundImage: NetworkImage('${widget.user.image}'),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Row(
            children: [
              widget.message.type == 'image'
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => BigImage(image: widget.message.msg));
                        },
                        child: Image.network(
                          "${widget.message.msg}",
                          width: size.width * 0.5,
                        ),
                      ),
                    )
                  : AutoText(
                      "${widget.message.msg}",
                    ),
            ],
          ),
        ),
        AutoText(
          DateFormatter.getFormattedDate(
              context: context, time: widget.message.sent!),
          color: Colors.grey,
          fontSize: 11,
        )
      ],
    );
  }

  Widget buildMyselfMessages() {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.message.read == ""
                ? SizedBox()
                : AutoText("readed", color: Colors.grey, fontSize: 11),
            AutoText(
              DateFormatter.getFormattedDate(
                  context: context, time: widget.message.sent!),
              color: Colors.grey.shade400,
              fontSize: 11,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: widget.message.type == 'image'
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => BigImage(image: widget.message.msg));
                    },
                    child: Image.network(
                      "${widget.message.msg}",
                      width: size.width * 0.5,
                      // height: size.height * 0.2,
                    ),
                  ),
                )
              : AutoText(
                  "${widget.message.msg}",
                  color: Colors.white,
                ),
        ),
      ],
    );
  }
}
