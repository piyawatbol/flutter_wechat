import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BigImage extends StatelessWidget {
  final String? image;
  const BigImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage("${image}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
