import 'package:flutter/material.dart';
import 'package:test01/utilities/my_colors.dart';

Widget loading() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: MyColor.myPink,),
      ),
    ),
  );
}
