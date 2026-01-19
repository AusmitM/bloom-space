import 'package:flutter/material.dart';

Widget NavBar(
  String title,
  String sub1,
  String sub2,
  String sub3,
  String sub4,
  String sub5,
) {
  return AppBar(
    title: Text(title),
    bottom: TabBar(
      tabs: [
        Tab(text: sub1),
        Tab(text: sub2),
        Tab(text: sub3),
        Tab(text: sub4),
        Tab(text: sub5),
      ],
    ),
  );
}
