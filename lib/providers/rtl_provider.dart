import 'package:flutter/material.dart';

class RTLPro extends ChangeNotifier {
  bool rtlOpening = false;
  void changeOpening() {
    rtlOpening = !rtlOpening;
    notifyListeners();
  }
}
