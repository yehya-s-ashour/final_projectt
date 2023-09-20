import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/core/services/sender_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/categories_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/custum_textfield.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:flutter/material.dart';

class EditSenderDialouge extends StatefulWidget {
  SingleSender sender;
  FutureOr<dynamic> Function(void) dotThen;
  EditSenderDialouge({required this.sender, required this.dotThen});
  @override
  State<EditSenderDialouge> createState() => _EditSenderDialougeState();
}

class _EditSenderDialougeState extends State<EditSenderDialouge> {
  TextEditingController senderMobileCont = TextEditingController();
  TextEditingController senderNameCont = TextEditingController();
  late CategoryElement selectedCategory;
  @override
  void initState() {
    senderMobileCont.text = widget.sender.mobile!;
    senderNameCont.text = widget.sender.name!;
    selectedCategory = CategoryElement(
        id: widget.sender.category!.id,
        name: widget.sender.category!.name,
        createdAt: widget.sender.category!.createdAt.toString(),
        updatedAt: widget.sender.category!.updatedAt.toString(),
        sendersCount: '',
        senders: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Edit "${widget.sender.name}"',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        CustomWhiteBox(
          width: 400,
          height: 190,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: senderNameCont,
                      validationMessage: "Please enter a sender name".tr(),
                      onChanged: (value) {
                        setState(() {});
                      },
                      hintText: "Sender".tr(),
                      hintTextColor: Colors.grey,
                      isPrefixIcon: true,
                      isSuffixIcon: true,
                      isUnderlinedBorderEnabled: true,
                      prefixIcon: const Icon(
                        Icons.person_3_outlined,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: senderMobileCont,
                validationMessage: "Please enter a mobile number".tr(),
                hintText: "Mobile".tr(),
                hintTextColor: Colors.grey,
                isPrefixIcon: true,
                isSuffixIcon: false,
                isUnderlinedBorderEnabled: true,
                prefixIcon: const Icon(
                  Icons.phone_android_rounded,
                  size: 23,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final selectedCategory =
                      await showModalBottomSheet<CategoryElement>(
                    clipBehavior: Clip.hardEdge,
                    isScrollControlled: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return const categoriesBottomSheet();
                    },
                  );
                  setState(() {
                    if (selectedCategory != null) {
                      this.selectedCategory = selectedCategory;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 25.0,
                    end: 20.0,
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'images/category-icon.png',
                        width: 22,
                        height: 22,
                        color: Colors.black,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Category'.tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Iphone',
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              selectedCategory.name!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () async {
                updateSender(
                  categoryId: selectedCategory.id.toString(),
                  mobile: senderMobileCont.text,
                  name: senderNameCont.text,
                  senderId: widget.sender.id,
                ).then(widget.dotThen);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
