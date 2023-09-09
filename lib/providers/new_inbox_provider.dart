import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewInboxProvider extends ChangeNotifier {
  List<XFile?> imagesFiles = [];

  List<Map<String, dynamic>>? activites = [];

  late String archiveNumber;
  late DateTime date;
  String? senderName = '';
  String? senderMobile = '';
  String? titleOfMail = '';
  String? description = '';

  clearImages() {
    if (imagesFiles.isNotEmpty) {
      imagesFiles.clear();
      notifyListeners();
    } else
      debugPrint('images list is alerady empty');
  }

  void getImagesFromGallery() async {
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      imagesFiles.addAll(pickedFiles);
      notifyListeners();
    }
  }

  addActivity(String activity, String userId) async {
    activites!.add({
      'body': activity,
      'user_id': userId,
    });
    notifyListeners();
  }

  setArchiveNumber(String archiveNumber) {
    this.archiveNumber = archiveNumber;
    notifyListeners();
  }

  setDate(DateTime date) {
    this.date = date;
    notifyListeners();
  }
}
