import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/main_screen.dart';
import 'package:final_projectt/core/services/mail_controller.dart';
import 'package:final_projectt/core/services/new_inbox_controller.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/activites_expansion_tile.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/core/widgets/date_picker.dart';
import 'package:final_projectt/core/widgets/my_custom_dialouge.dart';
import 'package:final_projectt/core/widgets/edit_mail_more_sheet.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

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
  bool? isDecisionFilled;
  SingleSender? selectedSender;
  List<TagElement> selectedTags = [];
  bool isDeleting = false;
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;
  TextEditingController decisionCont = TextEditingController();
  TextEditingController activityTextFieldController = TextEditingController();
  late UserModel user;
  late String category = 'Other';
  DateTime? date;
  bool isUploading = false;
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

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    if (kDebugMode) {
      print("Waiting for boundary to be painted.");
    }
    await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
    }
    // }
  }

  void _onShareXFileFromAssets(BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  @override
  void initState() {
    intializeData();
    completedStatusId = (widget.mail.statusId == '4');
    isDecisionFilled = (widget.mail.decision == '');
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int year = date!.year;
    int today = date!.day;
    dynamic month = getMonth(date!);
    return RepaintBoundary(
      key: globalKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15,
                top: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(top: 0),
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const MainPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(-1.0,
                                  0.0); // Start from left (negative X direction)
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () async {
                          myCustomDialouge(
                            context: context,
                            title: 'Update mail?',
                            content: 'Do you want to update this mail?',
                            leftChoice: 'Cancel',
                            rightChoice: 'Update',
                            rightChoiceColor: primaryColor,
                            leftChoiceColor: Colors.red,
                            rightOnPressed: () async {
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
                                          duration:
                                              Duration(milliseconds: 1000),
                                          color: Colors.white,
                                          size: 40,
                                        ));
                                      },
                                    )
                                  : null;
                              final isUploaded = (Provider.of<NewInboxProvider>(
                                          context,
                                          listen: false)
                                      .imagesFiles
                                      .isNotEmpty
                                  ? await uploadImages(context, widget.mail.id!)
                                  : null);
                              final isUpdated = await updateMail(
                                mailId: widget.mail.id,
                                idAttachmentsForDelete:
                                    Provider.of<NewInboxProvider>(context,
                                            listen: false)
                                        .deletedImages
                                        .map((image) {
                                  return image!.id!;
                                }).toList(),
                                pathAttachmentsForDelete:
                                    Provider.of<NewInboxProvider>(context,
                                            listen: false)
                                        .deletedImages
                                        .map((image) {
                                  return image!.image!;
                                }).toList(),
                                statusId: selectedStatus.id.toString(),
                                decision: decisionCont.text,
                                finalDecision: decisionCont.text,
                                activities: Provider.of<NewInboxProvider>(
                                        context,
                                        listen: false)
                                    .activites,
                                tags:
                                    selectedTags.map((tag) => tag.id).toList(),
                              );
                              if (isUploaded! && isUpdated) {
                                showAlert(
                                  context,
                                  message: 'Mail Updated Successfully'.tr(),
                                  color: primaryColor.withOpacity(0.8),
                                  width: 230,
                                );

                                selectedTags = [];

                                final updateData = Provider.of<StatuseProvider>(
                                    context,
                                    listen: false);
                                updateData.updatestutas();

                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
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
                            },
                            leftOnPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: primaryColor,
                              size: 15,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 17,
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          clipBehavior: Clip.hardEdge,
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0),
                          )),
                          builder: (BuildContext context) {
                            return EditMailMoreSheet(
                              onShare: _capturePng,
                              onDelete: () {
                                myCustomDialouge(
                                  context: context,
                                  title: 'Delete mail?',
                                  content: 'Do you want to delete this mail?',
                                  leftChoice: 'Cancel',
                                  rightChoice: 'Delete',
                                  rightOnPressed: () async {
                                    setState(() {
                                      isDeleting = true;
                                    });
                                    await deleteMail(widget.mail.id.toString())!
                                        .then((value) {
                                      isDeleting = false;
                                      showAlert(context,
                                          message: 'Mail Deleted',
                                          color: Colors.red,
                                          width: 150);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return MainPage();
                                        },
                                      ));
                                    });
                                  },
                                  leftOnPressed: () {
                                    setState(() {
                                      isDeleting = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color: primaryColor,
                      ))
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
                                                SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    '${widget.mail.sender!.name}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                            .only(
                                                        top: 10.0, start: 35),
                                                child: Text(
                                                  '${widget.mail.sender!.category!.name}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  start: 10, top: 5),
                                          width: 1,
                                          height: 50,
                                          color: Colors.grey.shade300,
                                        ),
                                        Column(
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
                                                      start: 20),
                                              child: Text(
                                                '$today $month $year',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 20),
                                              child: SizedBox(
                                                width: 155,
                                                child: Text(
                                                  'Archive Number: ${widget.mail.archiveNumber}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
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
                        onTap: completedStatusId!
                            ? null
                            : () async {
                                final selectedTags = await showModalBottomSheet<
                                        List<TagElement>>(
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
                                              this.selectedTags,
                                        );
                                      });
                                    }).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      this.selectedTags = value;
                                    });
                                  }
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
                                    const Icon(
                                      Icons.tag,
                                      size: 23,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Tags'.tr(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
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
                                  if (value != null) {
                                    setState(() {
                                      this.selectedStatus = value;
                                    });
                                  }
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
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 25.0,
                                end: 20.0,
                                top: 20.0,
                              ),
                              child: Text(
                                'Descision'.tr(),
                                style: const TextStyle(
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
                                  hintText: isDecisionFilled!
                                      ? "Add Decsision ...".tr()
                                      : 'No decision yet',
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
                              ? 80 +
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
                                              'Add image'.tr(),
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
                                                                      350,
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
                                                      completedStatusId!
                                                          ? SizedBox.shrink()
                                                          : IconButton(
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

                                                                provider
                                                                    .networkImagesFiles
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline_rounded,
                                                                color:
                                                                    Colors.red,
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
                      ActivitesExpansionTile(),
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
