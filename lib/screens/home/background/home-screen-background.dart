import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jukebox_flutter/global/themes/color-themes.dart';

class HomeScreenBackground extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    mainCanvas(canvas, size);
  }
  
    @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  mainCanvas(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    path.lineTo(0, size.height * 0.30);
    path.quadraticBezierTo(size.width*0.1, size.height*0.30, size.width, size.height* 0.30);
    path.lineTo(size.width, 0);

    path.close();

    paint.color = ColorThemes.background;

    canvas.drawPath(path, paint);
  }
}