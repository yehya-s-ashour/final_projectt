import 'dart:io';

import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/activites_expansion_tile.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/core/widgets/show_alert.dart';
import 'package:final_projectt/core/widgets/status_bottom_sheet.dart';
import 'package:final_projectt/core/widgets/tags_bottom_sheet.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:final_projectt/models/status_model.dart';
import 'package:final_projectt/models/tags_model.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:final_projectt/providers/status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMailBottomSheet extends StatefulWidget {
  Mail mail;
  EditMailBottomSheet({super.key, required this.mail});

  @override
  State<EditMailBottomSheet> createState() => _EditMailBottomSheetState();
}

class _EditMailBottomSheetState extends State<EditMailBottomSheet> {
  TextEditingController senderNameCont = TextEditingController();
  TextEditingController senderMobileCont = TextEditingController();
  TextEditingController mailTitleCont = TextEditingController();
  TextEditingController mailDescriptionCont = TextEditingController();
  TextEditingController archiveNumberCont = TextEditingController();
  bool isExpansionOpened = false;

  SingleSender? selectedSender;
  List<TagElement> selectedTags = [];

  TextEditingController decisionCont = TextEditingController();
  TextEditingController activityTextFieldController = TextEditingController();
  late UserModel user;
  late String category = 'Other';
  DateTime? date;
  bool isValidationShown = false;
  late StatusMod selectedStatus = StatusMod(
      id: 1,
      name: 'Inbox',
      color: '0xfffa3a57',
      createdAt: '',
      updatedAt: '',
      mailsCount: '');
  bool? completedStatusId;
  getUser() async {
    user = await UserController().getLocalUser();
  }

  void intializeData() {
    if (widget.mail.archiveDate != null) {
      date = DateTime.parse(widget.mail.archiveDate!);
    } else {
      debugPrint('archive date is null');
    }
    if (widget.mail.tags != null) {
      List<TagElement> tags = widget.mail.tags!.map((tag) {
        return TagElement(
          id: tag.id!,
          name: tag.name!,
          createdAt: tag.createdAt!,
          updatedAt: tag.updatedAt!,
        );
      }).toList();
      selectedTags = tags;
    } else {
      debugPrint('archive date is null');
    }
    if (widget.mail.attachments!.isNotEmpty) {
      Provider.of<NewInboxProvider>(context, listen: false)
          .setNetworkImagesList(widget.mail.attachments!);
    } else {
      debugPrint('attachments is null');
    }

    // if (widget.mail.activities!.isNotEmpty) {
    //   List<Map<String, dynamic>>? activites =
    //       widget.mail.activities!.map((activity) {
    //     return {
    //       'body': activity.body,
    //       'user_id': activity.id,
    //     };
    //   }).toList();
    //   Provider.of<NewInboxProvider>(context, listen: false)
    //       .setActivitesList(activites);
    // } else {
    //   debugPrint('activites is null');
    // }
    if (widget.mail.status != null) {
      final status = widget.mail.status!;
      selectedStatus = StatusMod(
        color: status.color,
        id: status.id,
        name: status.name,
      );
    } else {
      debugPrint('status is null');
    }
    // selectedTags = widget.mail.tags!;
    decisionCont.text = widget.mail.decision ?? '';
  }

  @override
  void initState() {
    intializeData();
    completedStatusId = (widget.mail.statusId == '4');

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int year = date!.year;
    int today = date!.day;
    dynamic month = getMonth(date!);
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
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                    ),
                  ),
                  const Text(
                    'Mail Details',
                    style: TextStyle(fontSize: 20, color: Color(0xFF272727)),
                  ),
                  TextButton(
                    onPressed: () async {
                      Provider.of<NewInboxProvider>(context, listen: false)
                              .imagesFiles
                              .isNotEmpty
                          ? await uploadImages(context, widget.mail.id!)
                          : null;
                      await updateMail(
                        mailId: widget.mail.id,
                        idAttachmentsForDelete: Provider.of<NewInboxProvider>(
                                context,
                                listen: false)
                            .deletedImages
                            .map((image) {
                          return image!.id!;
                        }).toList(),
                        pathAttachmentsForDelete: Provider.of<NewInboxProvider>(
                                context,
                                listen: false)
                            .deletedImages
                            .map((image) {
                          return image!.image!;
                        }).toList(),
                        statusId: selectedStatus.id.toString(),
                        decision: decisionCont.text,
                        finalDecision: decisionCont.text,
                        activities: Provider.of<NewInboxProvider>(context,
                                listen: false)
                            .activites,
                        tags: selectedTags.map((tag) => tag.id).toList(),
                      );

                      showAlert(
                        context,
                        message: 'Mail Updated Successfully',
                        color: primaryColor.withOpacity(0.8),
                        width: 230,
                      );

                      selectedTags = [];

                      final updateData =
                          Provider.of<StatuseProvider>(context, listen: false);
                      updateData.updatestutas();

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return const MainPage();
                        },
                      ));
                    },
                    child: const Text('Done', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        height: isExpansionOpened ? 175 : 150,
                        width: 400,
                        duration: const Duration(milliseconds: 300),
                        child: CustomWhiteBox(
                            width: 400,
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 15.0, top: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.person_2_outlined,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${widget.mail.sender!.name}',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                          .only(
                                                      top: 10.0, start: 35),
                                              child: Text(
                                                '${widget.mail.sender!.category!.name}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  top: 5),
                                          width: 1,
                                          height: 50,
                                          color: Colors.grey.shade300,
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  '$today $month $year',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  'Archive Number: ${widget.mail.archiveNumber}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          top: 15),
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ListTileTheme(
                                        contentPadding:
                                            const EdgeInsetsDirectional.only(
                                                start: 10),
                                        dense: true,
                                        child: ExpansionTile(
                                            onExpansionChanged: (value) {
                                              setState(() {
                                                isExpansionOpened = value;
                                              });
                                            },
                                            textColor: const Color(0xff272727),
                                            trailing: SizedBox(
                                              width: 60,
                                              child: Center(
                                                child: Icon(
                                                  !isExpansionOpened
                                                      ? Icons
                                                          .arrow_forward_ios_rounded
                                                      : Icons
                                                          .keyboard_arrow_up_rounded,
                                                  size: isExpansionOpened
                                                      ? 30
                                                      : 20,
                                                  color: !isExpansionOpened
                                                      ? Colors.grey
                                                      : primaryColor,
                                                ),
                                              ),
                                            ),
                                            initiallyExpanded: false,
                                            title: Text(
                                              widget.mail.subject!,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: [
                                              Text(
                                                widget.mail.description == ''
                                                    ? '${widget.mail.description}'
                                                    : 'No Description',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
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
                                        givenTagsFromOutSide: this.selectedTags,
                                      );
                                    });
                                  }).then((value) {
                            setState(() {
                              this.selectedTags = value!;
                            });
                          });
                        },
                        child: CustomWhiteBox(
                          width: 378,
                          height: 56,
                          child: const Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 20.0,
                              end: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.tag,
                                      size: 23,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Tags',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: completedStatusId!
                            ? null
                            : () async {
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
                                      status: StatusMod(
                                        color: widget.mail.status!.color,
                                        id: this.selectedStatus.id,
                                        name: widget.mail.status!.name,
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  setState(() {
                                    this.selectedStatus = value!;
                                  });
                                });
                              },
                        child: CustomWhiteBox(
                          width: 378,
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 20.0,
                              end: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          final textLength = statusText!.length;
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
                                              '${selectedStatus.name}',
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
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomWhiteBox(
                        width: 378,
                        height: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 25.0,
                                end: 20.0,
                                top: 20.0,
                              ),
                              child: Text(
                                'Descision',
                                style: TextStyle(
                                  fontSize: 20,
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
                                  enabled: completedStatusId! ? false : true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  border: InputBorder.none,
                                  hintText: "Add Decsision ...",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Iphone',
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: completedStatusId!
                            ? null
                            : () {
                                Provider.of<NewInboxProvider>(context,
                                        listen: false)
                                    .getImagesFromGallery();
                              },
                        child: AnimatedContainer(
                          height: Provider.of<NewInboxProvider>(context)
                                      .networkImagesFiles
                                      .isNotEmpty ||
                                  Provider.of<NewInboxProvider>(context)
                                      .imagesFiles
                                      .isNotEmpty
                              ? 95 +
                                  (((Provider.of<NewInboxProvider>(context)
                                              .networkImagesFiles
                                              .length) +
                                          (Provider.of<NewInboxProvider>(
                                                  context)
                                              .imagesFiles
                                              .length)) *
                                      57)
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
                                  end: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              'Add image',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontFamily: 'Iphone',
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                    Provider.of<NewInboxProvider>(context)
                                            .networkImagesFiles
                                            .isNotEmpty
                                        ? SizedBox(
                                            height: 20 +
                                                ((Provider.of<NewInboxProvider>(
                                                            context)
                                                        .networkImagesFiles
                                                        .length) *
                                                    55),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  Provider.of<NewInboxProvider>(
                                                          context)
                                                      .networkImagesFiles
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () {
                                                    showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title:
                                                                    Container(
                                                                  width: 200,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height -
                                                                      250,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              NetworkImage('https://palmail.gsgtt.tech/storage/${Provider.of<NewInboxProvider>(context).networkImagesFiles[index]!.image}'))),
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
                                                            final provider =
                                                                Provider.of<
                                                                        NewInboxProvider>(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            provider
                                                                .deletedImages
                                                                .add(provider
                                                                        .networkImagesFiles[
                                                                    index]!);
                                                            print(provider
                                                                .deletedImages);
                                                            provider
                                                                .networkImagesFiles
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
                                                        margin: const EdgeInsets
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
                                                                image: NetworkImage(
                                                                    'https://palmail.gsgtt.tech/storage/${Provider.of<NewInboxProvider>(context).networkImagesFiles[index]!.image}'))),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          '${Provider.of<NewInboxProvider>(context).networkImagesFiles[index]!.title}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 17),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    Provider.of<NewInboxProvider>(context)
                                            .imagesFiles
                                            .isNotEmpty
                                        ? SizedBox(
                                            height: 55 +
                                                ((Provider.of<NewInboxProvider>(
                                                            context)
                                                        .imagesFiles
                                                        .length) *
                                                    57),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount:
                                                  Provider.of<NewInboxProvider>(
                                                          context)
                                                      .imagesFiles
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () {
                                                    showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                title:
                                                                    Container(
                                                                  width: 200,
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height -
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
                                                        margin: const EdgeInsets
                                                            .all(7),
                                                        width: 38,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            11),
                                                                image:
                                                                    DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image:
                                                                            FileImage(
                                                                          File(Provider.of<NewInboxProvider>(context)
                                                                              .imagesFiles[index]!
                                                                              .path),
                                                                        ))),
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 17),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const ActivitesExpansionTile(),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20.0, end: 20.0, bottom: 20, top: 5),
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
                            hintText: "Add new activity ...",
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
