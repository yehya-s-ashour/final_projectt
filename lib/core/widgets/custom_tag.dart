import 'package:flutter/material.dart';

InkWell customTag(String tagName) {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffE6E6E6)),
      child: Text(
        tagName,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  );
}
