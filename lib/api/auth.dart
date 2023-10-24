import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/model/chat_user_model.dart';
import 'package:we_chat/model/message_model.dart';
import 'package:http/http.dart' as http;

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseMessaging Fmessaging = FirebaseMessaging.instance;
  static User get user => auth.currentUser!;
  static late ChatUserModel me;

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log(data.toString());

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "hello",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: true,
        lastActive: time,
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Future<void> getSelfInfo() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUserModel.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static Future<void> sendMessage(
      ChatUserModel chatUser, String msg, String type) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final MessageModel message = MessageModel(
      told: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      formId: user.uid,
      sent: time,
    );

    final ref = firestore.collection(
        'chats/${getConversationID(chatUser.id.toString())}/messages/');

    await ref.doc(time).set(message.toJson()).then((value) {
      sendPushNotification(chatUser, type == 'text' ? msg : 'image');
    });
  }

  static Future<void> updateMessageReadStatus(MessageModel message) async {
    firestore
        .collection('chats/${getConversationID(message.formId!)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUserModel chatuser, File file) async {
    final ext = file.path.split('.').last;
    final ref = APIs.storage.ref().child(
        'images/${getConversationID(chatuser.id!)}/${DateTime.now().microsecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => log('success'));
    var image = await ref.getDownloadURL();
    await sendMessage(chatuser, image, 'image');
  }

  static Future<void> getFirebaseMessagingToken() async {
    await Fmessaging.requestPermission();
    await Fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('push token : $t');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Got a message whilst in the foreground");
      log("Messsage Data : ${message.data}");
      if (message.notification != null) {
        log("Message also contained a notification : ${message.notification}");
      }
    });
  }

  static Future<void> sendPushNotification(
      ChatUserModel chatUser, String msg) async {
    final body = {
      "to": chatUser.pushToken,
      "notification": {
        "title": chatUser.name,
        "body": msg,
        "android_channel_id": "chats",
      },
      "data": {"some_data": "User ID : ${me.id}"}
    };
    var response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'key=AAAA6aifjyo:APA91bGARMNbXgl1UzR7ReO6oc2JsBLrM3QQyHqN6JaTOKOfYsz176IkGlV7As0oWMtFXLN_VFECalIF_sttUq03PJkpJiDenSaCfo-3wFT39GmAw-uZapYypbrsiHEycWM8BnyDFneD'
      },
      body: jsonEncode(body),
    );
    print(response.body);
  }
}
