import 'package:flutter/material.dart';

Widget buildButtonPanelItem(IconData iconData, String text,
    {double? fontSize = 12}) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Column(
      children: [
        Icon(
          iconData,
        ),
        const SizedBox(height: 4),
        Text(text,
            style: TextStyle(
              fontSize: fontSize,
            )),
      ],
    ),
  );
}
