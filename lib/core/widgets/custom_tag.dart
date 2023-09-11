import 'package:flutter/material.dart';

Container customTag(String tagName) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffE6E6E6)),
    child: Text(
      tagName,
      style: const TextStyle(fontSize: 14),
    ),
  );
}
