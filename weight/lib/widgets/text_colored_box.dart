import 'package:flutter/material.dart';

Widget textWithColorBox(String text, Color color) {
  return Row(
    children: [
      Container(
        width: 5,
        height: 5,
        color: color,
      ),
      const SizedBox(width: 2),
      Text(text, style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 2),
    ],
  );
}
