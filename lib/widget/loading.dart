import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final statusLoading;
  Loading({required this.statusLoading});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Visibility(
      visible: statusLoading == true ? true : false,
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.white10,
            ),
            Positioned(
              child: Container(
                width: size.width * 0.25,
                height: size.height * 0.12,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: SpinKitFadingCircle(
                  color: Color(0xFF398AE5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
