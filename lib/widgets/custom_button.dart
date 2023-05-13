import 'package:flutter/material.dart';
import '../consts/consts.dart';

Widget ourbutton({
  required VoidCallback onpressed,
  Color? textcolor,
  String? title,
}) {
  return SizedBox(
    height: 45,
    child: ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffff2d55),
      ),
      child: title?.text.color(textcolor ?? Colors.white).fontFamily(bold).make(),
    ),
  );
}
