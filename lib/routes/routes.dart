import 'package:get/get.dart';
import 'package:we_chat/screen/home/add_friend_screen.dart';
import 'package:we_chat/screen/home/chat_screen.dart';
import 'package:we_chat/screen/home/home_screen.dart';
import 'package:we_chat/screen/login/login_screen.dart';
import 'package:we_chat/screen/profile/profile_screen.dart';
import 'package:we_chat/splash_screen.dart';

class AppRoutes {
  static final getPages = [
    GetPage(
      name: '/',
      page: () => SplachScreen(),
    ),
    GetPage(
      name: '/login_screen',
      page: () => LoginScreen(),
    ),
    GetPage(
      name: '/home_screen',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: '/chat',
      page: () => ChatScreen(),
    ),
    GetPage(
      name: '/add_friend',
      page: () => AddFriendScreen(),
    ),
  ];
}
