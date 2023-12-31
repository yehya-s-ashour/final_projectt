import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/services/mail_controller.dart';
import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/activites_expansion_tile.dart';
import 'package:final_projectt/core/widgets/categories_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/custum_textfield.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/core/widgets/senders_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/core/widgets/status_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/tags_bottom_sheet.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class NewInboxBottomSheet extends StatefulWidget {
  const NewInboxBottomSheet({super.key});

  @override
  State<NewInboxBottomSheet> createState() => _NewInboxBottomSheetState();
}

class _NewInboxBottomSheetState extends State<NewInboxBottomSheet> {
  TextEditingController senderMobileCont = TextEditingController();
  TextEditingController senderNameCont = TextEditingController();
  TextEditingController mailTitleCont = TextEditingController();
  TextEditingController mailDescriptionCont = TextEditingController();
  TextEditingController archiveNumber = TextEditingController();
  bool isUploading = false;

  dynamic selectedSender;
  List<TagElement>? selectedTags = [];

  TextEditingController decisionCont = TextEditingController();
  TextEditingController activityTextFieldController = TextEditingController();
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  late CategoryElement selectedCategory = CategoryElement(
    createdAt: '',
    id: 1,
    name: 'Other',
    senders: [],
    sendersCount: '',
    updatedAt: '',
  );
  bool isNameMobileFilled = true;
  bool? isSenderNameFilled = false;
  bool isValidationShown = false;
  late StatusMod selectedStatus = StatusMod(
      id: 1,
      name: 'Inbox',
      color: '0xfffa3a57',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      mailsCount: '');

  getUser() async {
    user = await UserController().getLocalUser();
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 55,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.only(left: 10),
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel'.tr(),
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                  Text(
                    'New Inbox'.tr(),
                    style:
                        const TextStyle(fontSize: 20, color: Color(0xFF272727)),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isUploading = true;
                        });
                        isUploading
                            ? showCupertinoDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                      child: SpinKitPulse(
                                    duration: Duration(milliseconds: 1000),
                                    color: Colors.white,
                                    size: 40,
                                  ));
                                },
                              )
                            : null;

                        NewSender? newSender;
                        String? senderId;
                        if (selectedSender == null ||
                            selectedSender is String) {
                          newSender = await createSender(
                            categoryId: selectedCategory.id?.toString(),
                            mobile: senderMobileCont.text,
                            name: senderNameCont.text,
                          );
                          senderId = newSender!.singleSender![0].id.toString();
                        }

                        if (newSender == null) {
                          senderId = selectedSender!.id.toString();
                        }

                        final createMailResponse = await newInbox(
                          statusId: '${selectedStatus.id}',
                          decision: decisionCont.text,
                          senderId: senderId.toString(),
                          finalDecision: decisionCont.text,
                          activities: Provider.of<NewInboxProvider>(context,
                                  listen: false)
                              .activites,
                          tags: selectedTags!.map((tag) => tag.id).toList(),
                          subject: mailTitleCont.text,
                          description: mailDescriptionCont.text,
                          archiveNumber: Provider.of<NewInboxProvider>(context,
                                  listen: false)
                              .archiveNumber,
                          archiveDate: Provider.of<NewInboxProvider>(context,
                                  listen: false)
                              .date
                              .toString(),
                        );
                        final isUploaded = await uploadImages(
                            context, createMailResponse.mail!.id!);

                        if (isUploaded) {
                          setState(() {
                            isUploading = false;
                          });
                          setState(() {
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .clearImages();
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .senderName = '';
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .senderMobile = '';
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .activites = [];
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .isDatePickerOpened = false;
                          });
                          showAlert(context,
                              message: 'Mail Created Successfully'.tr(),
                              color: primaryColor.withOpacity(0.8),
                              width: 230);

                          selectedTags = [];
                          getMails();
                          final updateData = Provider.of<StatuseProvider>(
                              context,
                              listen: false);
                          updateData.updatestutas();

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return const MainPage();
                            },
                          ));
                        } else {
                          showAlert(
                            context,
                            message: 'Something went wrong'.tr(),
                            color: Colors.red,
                            width: 230,
                          );
                          Navigator.pop(context);
                        }
                      } else {
                        setState(() {
                          isValidationShown = true;
                        });
                      }
                    },
                    child:
                        Text('Done'.tr(), style: const TextStyle(fontSize: 19)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 400,
                          height: !isSenderNameFilled!
                              ? (!isValidationShown
                                  ? context.locale.toString() == "ar"
                                      ? 80
                                      : 70
                                  : context.locale.toString() == "ar"
                                      ? 130
                                      : 110)
                              : (!isValidationShown
                                  ? 200
                                  : context.locale.toString() == "ar"
                                      ? 265
                                      : 230),
                          child: CustomWhiteBox(
                            width: 400,
                            height: 230,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Theme(
                                          data: ThemeData(
                                            disabledColor: Colors.black,
                                          ),
                                          child: CustomTextField(
                                            controller: senderNameCont,
                                            validationMessage:
                                                "Please enter a sender name"
                                                    .tr(),
                                            onChanged: (value) {
                                              setState(() {
                                                isSenderNameFilled = true;
                                              });
                                            },
                                            isEnabled: isNameMobileFilled,
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
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 8.0, bottom: 7),
                                        child: IconButton(
                                          onPressed: () async {
                                            selectedSender = null;
                                            selectedSender =
                                                await showModalBottomSheet(
                                              clipBehavior: Clip.hardEdge,
                                              isScrollControlled: true,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(15.0),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return const SendersBottomSheet();
                                              },
                                            );
                                            if (selectedSender != null) {
                                              if (selectedSender is String) {
                                                setState(() {
                                                  isSenderNameFilled = true;
                                                  isNameMobileFilled = true;
                                                  senderNameCont.text =
                                                      selectedSender;
                                                });
                                              } else if (selectedSender
                                                  is SingleSender) {
                                                setState(() {
                                                  isSenderNameFilled = true;
                                                  senderNameCont.text =
                                                      selectedSender.name;
                                                  isNameMobileFilled = false;
                                                  senderMobileCont.text =
                                                      selectedSender.mobile;
                                                });
                                              }
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.info_outline,
                                            color: Color(0xff6589FF),
                                            size: 27,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  !isSenderNameFilled!
                                      ? const SizedBox()
                                      : Theme(
                                          data: ThemeData(
                                            disabledColor: Colors.black,
                                          ),
                                          child: CustomTextField(
                                            controller: senderMobileCont,
                                            validationMessage:
                                                "Please enter a mobile number"
                                                    .tr(),
                                            hintText: "Mobile".tr(),
                                            isEnabled: isNameMobileFilled,
                                            hintTextColor: Colors.grey,
                                            isPrefixIcon: true,
                                            isSuffixIcon: false,
                                            isUnderlinedBorderEnabled: true,
                                            prefixIcon: const Icon(
                                              Icons.phone_android_rounded,
                                              size: 23,
                                            ),
                                          ),
                                        ),
                                  !isSenderNameFilled!
                                      ? const SizedBox()
                                      : GestureDetector(
                                          onTap: selectedSender != null &&
                                                  selectedSender.runtimeType ==
                                                      SingleSender
                                              ? null
                                              : () async {
                                                  final selectedCategory =
                                                      await showModalBottomSheet<
                                                          CategoryElement>(
                                                    clipBehavior: Clip.hardEdge,
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            15.0),
                                                      ),
                                                    ),
                                                    builder:
                                                        (BuildContext context) {
                                                      return const categoriesBottomSheet();
                                                    },
                                                  );
                                                  setState(() {
                                                    if (selectedCategory !=
                                                        null) {
                                                      this.selectedCategory =
                                                          selectedCategory;
                                                    }
                                                  });
                                                },
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              start: 30.0,
                                              end: 20.0,
                                              top: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Category'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iphone',
                                                      fontSize: 18),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            selectedSender
                                                                        .runtimeType ==
                                                                    SingleSender
                                                                ? selectedSender
                                                                    ?.category
                                                                    ?.name
                                                                : selectedCategory
                                                                    .name,
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.end,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          color: Colors.black54,
                                                          size: 15,
                                                        ),
                                                      ],
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
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 400,
                          height: isValidationShown
                              ? context.locale.toString() == "ar"
                                  ? 180
                                  : 155
                              : context.locale.toString() == "ar"
                                  ? 150
                                  : 135,
                          child: CustomWhiteBox(
                            width: 378,
                            height: 155,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: mailTitleCont,
                                    validationMessage:
                                        "Please enter a title of mail".tr(),
                                    hintText: "Title of mail".tr(),
                                    hintTextColor: Colors.grey,
                                    isPrefixIcon: false,
                                    isSuffixIcon: false,
                                    isUnderlinedBorderEnabled: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 10.0, end: 10.0),
                                    child: TextFormField(
                                      controller: mailDescriptionCont,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 25),
                                        border: InputBorder.none,
                                        hintText: 'Description'.tr(),
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Iphone',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          height: Provider.of<NewInboxProvider>(context)
                                  .isDatePickerOpened
                              ? context.locale.toString() == "ar"
                                  ? 550
                                  : 515.0
                              : (isValidationShown
                                  ? context.locale.toString() == "ar"
                                      ? 200
                                      : 190
                                  : 165),
                          duration: const Duration(milliseconds: 300),
                          child: CustomWhiteBox(
                            width: 378,
                            height: 480,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  CustomDatePicker(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 22.0, top: 10, right: 22),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.folder_zip_outlined,
                                          color: Colors.blueGrey,
                                          size: 23,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text('Archive number'.tr(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Iphone',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: context.locale.toString() == "ar"
                                            ? 10
                                            : 65.0,
                                        right: context.locale.toString() == "ar"
                                            ? 65.0
                                            : 10),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        Provider.of<NewInboxProvider>(context,
                                                listen: false)
                                            .setArchiveNumber(value);
                                      },
                                      controller: archiveNumber,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter an archive number"
                                              .tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "like 102/2022".tr(),
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontFamily: 'Iphone',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          errorBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final selectedTags =
                                await showModalBottomSheet<List<TagElement>>(
                                    clipBehavior: Clip.hardEdge,
                                    isScrollControlled: true,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0),
                                    )),
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return TagsBottomSheet(
                                          givenTagsFromOutSide:
                                              this.selectedTags!,
                                        );
                                      });
                                    });
                            setState(() {
                              if (selectedTags != null) {
                                this.selectedTags = selectedTags;
                              }
                            });
                          },
                          child: CustomWhiteBox(
                            width: 378,
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 30.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.tag,
                                        size: 23,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Tags'.tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iphone',
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final selectedStatus =
                                await showModalBottomSheet<StatusMod>(
                              clipBehavior: Clip.hardEdge,
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return StatusesBottomSheet(
                                  status: this.selectedStatus,
                                );
                              },
                            );
                            setState(() {
                              if (selectedStatus != null) {
                                this.selectedStatus = selectedStatus;
                              }
                            });
                          },
                          child: CustomWhiteBox(
                            width: 378,
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 20.0,
                                end: 30.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image.asset(
                                          'images/Tag.png',
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        height: 32,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final statusText =
                                                selectedStatus.name;
                                            final textLength =
                                                statusText!.length;
                                            final statusWidth =
                                                40.0 + (textLength * 7.0);
                                            return Container(
                                              alignment: Alignment.center,
                                              width: statusWidth,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                    selectedStatus.color!)),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                '${selectedStatus.name}'.tr(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            );
                                          },
                                          itemCount: 1,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 10,
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomWhiteBox(
                          width: 378,
                          height: context.locale.toString() == "ar" ? 120 : 110,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 25.0,
                                  end: 20.0,
                                  top: 20.0,
                                ),
                                child: Text(
                                  'Descision'.tr(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 10.0, end: 10.0),
                                child: TextFormField(
                                  onChanged: (value) {
                                    Provider.of<NewInboxProvider>(context,
                                            listen: false)
                                        .setArchiveNumber(value);
                                  },
                                  controller: decisionCont,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40),
                                    border: InputBorder.none,
                                    hintText: "Add Decsision ...".tr(),
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iphone',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Provider.of<NewInboxProvider>(context,
                                    listen: false)
                                .getImagesFromGallery();
                          },
                          child: AnimatedContainer(
                            height: Provider.of<NewInboxProvider>(context)
                                    .imagesFiles
                                    .isNotEmpty
                                ? 95 +
                                    ((Provider.of<NewInboxProvider>(context)
                                            .imagesFiles
                                            .length) *
                                        55)
                                : context.locale.toString() == "ar"
                                    ? 85
                                    : 75.0,
                            duration: const Duration(milliseconds: 300),
                            child: CustomWhiteBox(
                              width: 378,
                              height: 120,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    top: 20,
                                    start: 20.0,
                                    end: 30.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.image,
                                                color: Colors.blueGrey,
                                                size: 23,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                'Add image'.tr(),
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontFamily: 'Iphone',
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black54,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                      Provider.of<NewInboxProvider>(context)
                                              .imagesFiles
                                              .isNotEmpty
                                          ? SizedBox(
                                              height: Provider.of<
                                                              NewInboxProvider>(
                                                          context)
                                                      .imagesFiles
                                                      .isNotEmpty
                                                  ? 55 +
                                                      ((Provider.of<NewInboxProvider>(
                                                                  context)
                                                              .imagesFiles
                                                              .length) *
                                                          57)
                                                  : 50.0,
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: Provider.of<
                                                            NewInboxProvider>(
                                                        context)
                                                    .imagesFiles
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      showDialog(
                                                        barrierDismissible:
                                                            true,
                                                        context: context,
                                                        builder: (context) {
                                                          return Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                SingleChildScrollView(
                                                              child:
                                                                  AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      titlePadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      title:
                                                                          Container(
                                                                        width:
                                                                            200,
                                                                        height: MediaQuery.sizeOf(context).height -
                                                                            250,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(30),
                                                                            image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: FileImage(
                                                                                  File(Provider.of<NewInboxProvider>(context).imagesFiles[index]!.path),
                                                                                ))),
                                                                      )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    title: Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Provider.of<NewInboxProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .imagesFiles
                                                                  .removeAt(
                                                                      index);
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_outline_rounded,
                                                              color: Colors.red,
                                                            )),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(7),
                                                          width: 38,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: FileImage(File(Provider.of<
                                                                              NewInboxProvider>(
                                                                          context)
                                                                      .imagesFiles[
                                                                          index]!
                                                                      .path)))),
                                                        ),
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            Provider.of<NewInboxProvider>(
                                                                    context)
                                                                .imagesFiles[
                                                                    index]!
                                                                .name,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        17),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 380, child: ActivitesExpansionTile()),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 20.0, end: 20.0, bottom: 20),
                          child: TextField(
                            controller: activityTextFieldController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<NewInboxProvider>(context,
                                              listen: false)
                                          .addActivity(
                                              activityTextFieldController.text,
                                              user.user.id.toString());
                                      activityTextFieldController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: primaryColor,
                                  )),
                              //should be replaced with profie image
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.05),
                              contentPadding: const EdgeInsets.all(15),
                              hintText: "Add new activity ...".tr(),
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 17),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: backGroundColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: backGroundColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
