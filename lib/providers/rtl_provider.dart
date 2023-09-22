import 'package:final_projectt/core/widgets/my_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class RTLPro extends ChangeNotifier {
  bool rtlOpening = false;
  bool isExpanded = false;
  // AdvancedDrawerController advancedDrawerController =
  //     AdvancedDrawerController();

  void changeOpening() {
    rtlOpening = !rtlOpening;
    notifyListeners();
  }

  void changeExpnaded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  // void handleMenuButtonPressed() {
  //   advancedDrawerController.showDrawer();
  //   hideOverlay();
  //   notifyListeners();
  // }
}
