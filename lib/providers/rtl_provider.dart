import 'package:flutter/material.dart';

class RTLPro extends ChangeNotifier {
  bool rtlOpening = false;
  bool isExpanded = false;
  void changeOpening() {
    rtlOpening = !rtlOpening;
    notifyListeners();
  }

  void changeExpnaded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}
