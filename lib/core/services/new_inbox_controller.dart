import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future pickImageFromGallery() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  return image;
}

class BottomSheeeet extends StatelessWidget {
  const BottomSheeeet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding:
                    EdgeInsetsDirectional.only(top: 25, start: 20, end: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                ));
          });
        });
  }
}
