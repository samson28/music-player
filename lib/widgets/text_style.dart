import 'package:flutter/material.dart';

Widget textStyle(String data, double scale) {
  return Text(
    data,
    textScaleFactor: scale,
    style: const TextStyle(
        color: Colors.black, fontSize: 20, fontStyle: FontStyle.italic),
  );
}
