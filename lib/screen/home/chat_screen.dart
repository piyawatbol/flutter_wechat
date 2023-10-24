import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/model/message_model.dart';
import 'package:we_chat/screen/widget/colors.dart';
import 'package:we_chat/widget/auto_text.dart';
import 'package:we_chat/widget/date_formatter.dart';
import 'package:we_chat/widget/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel? user;
  const ChatScreen({super.key, this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messageList = [];
  TextEditingController input = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  List fileList = [];
  bool showEmoji = false;
  bool uploadImage = false;

  pickImage() async {
    pickedFile = (await _picker.pickImage(source: ImageSource.gallery));
    setState(() {
      fileList.add(pickedFile!.path);
    });
  }

  pickCamera() async {
    pickedFile = (await _picker.pickImage(source: ImageSource.camera));
    setState(() {
      fileList.add(pickedFile!.path);
    });
  }

  lastindex() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          showEmoji = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                buildAppbar(),
                SizedBox(height: 25),
                buildMessages(),
                SizedBox(height: 10),
                buildInputBox(),
                buildEmoji()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAppbar() {
    return StreamBuilder(
      stream: APIs.getUserInfo(widget.user!),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            CircleAvatar(
              backgroundImage: NetworkImage('${widget.user!.image}'),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoText("${widget.user!.name}"),
                list.isEmpty
                    ? SizedBox()
                    : list[0].isOnline == true
                        ? AutoText(
                            'Online',
                            color: Colors.green,
                          )
                        : AutoText(
                            "${DateFormatter.getLastActiveTime(context: context, lastActive: list[0].lastActive.toString())}",
                            color: Colors.grey,
                          ),
              ],
            )
          ],
        );
      },
    );
  }

  buildMessages() {
    return Expanded(
      child: StreamBuilder(
          stream: APIs.getAllMessages(widget.user!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                messageList = data
                        ?.map((e) => MessageModel.fromJson(e.data()))
                        .toList() ??
                    [];
                if (messageList.isNotEmpty) {
                  lastindex();
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageCard(
                        message: messageList[index],
                        user: widget.user!,
                      );
                    },
                  );
                } else {
                  return Center(child: AutoText("Not found message"));
                }
            }
          }),
    );
  }

  buildInputBox() {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          fileList.isEmpty
              ? SizedBox()
              : Container(
                  height: size.height * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fileList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Stack(
                          children: [
                            Container(
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(fileList[index]),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      fileList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      );
                    },
                  )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showEmoji = !showEmoji;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          icon:
                              Icon(Icons.emoji_emotions, color: Colors.white)),
                      Expanded(
                          child: TextField(
                              onTap: () {
                                setState(() {
                                  showEmoji = false;
                                });
                              },
                              controller: input,
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration:
                                  InputDecoration(border: InputBorder.none))),
                      IconButton(
                          onPressed: () async {
                            await pickImage();
                          },
                          icon: Icon(Icons.image, color: Colors.white)),
                      IconButton(
                          onPressed: () async {
                            await pickCamera();
                          },
                          icon: Icon(Icons.camera_alt, color: Colors.white))
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (input.text != '') {
                    APIs.sendMessage(widget.user!, input.text, 'text');
                    setState(() => uploadImage = false);
                    input.text = '';
                  } else {
                    if (input.text != '') {
                      APIs.sendMessage(widget.user!, input.text, 'text');
                      input.text = '';
                      setState(() {
                        fileList.clear();
                      });
                      for (var i = 0; i < fileList.length; i++) {
                        setState(() {
                          uploadImage = true;
                        });
                        APIs.sendChatImage(widget.user!, File(fileList[i]));
                        setState(() {
                          uploadImage = false;
                        });
                      }
                    } else {
                      for (var i = 0; i < fileList.length; i++) {
                        setState(() {
                          uploadImage = true;
                        });
                        APIs.sendChatImage(widget.user!, File(fileList[i]));
                        setState(() {
                          uploadImage = false;
                        });
                      }
                      setState(() {
                        fileList.clear();
                      });
                    }
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 5)
            ],
          ),
        ],
      ),
    );
  }

  buildEmoji() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Visibility(
          visible: showEmoji,
          child: SizedBox(
            height: size.height * 0.3,
            child: EmojiPicker(
              onBackspacePressed: () {},
              textEditingController: input,
              config: Config(
                columns: 7,
              ),
            ),
          ),
        )
      ],
    );
  }
}
