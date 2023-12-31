import 'package:easy_localization/easy_localization.dart';
import 'package:final_projectt/Screens/single_tag_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/mail_model.dart';

Widget myCustomCard(Mail mail, VoidCallback onTap) {
  String dateTimeString = mail.archiveDate!;
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('yyyy  MMM  dd').format(dateTime);

  Widget getTags(List<MailTag>? tags) {
    if (tags != null && tags.isNotEmpty) {
      return SizedBox(
        height: 20,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String? tag = '#${tags[index].name}';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SingleTagScreen(
                          tagId: tags[index].id!,
                          tagName: '${tags[index].name}',
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
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
                      ));
                },
                child: Text(
                  tag,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff6589FF),
                      fontWeight: FontWeight.w400),
                ),
              );
            },
            separatorBuilder: ((context, index) {
              return const SizedBox(
                width: 5,
              );
            }),
            itemCount: tags.length),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getAttachments(List<Attachments>? attach) {
    if (attach != [] && attach!.isNotEmpty) {
      return SizedBox(
        height: 50,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: attach.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              String? path = attach[index].image;
              return GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 50,
                          width: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        )),
                    Container(
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 50,
                      width: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://palmail.gsgtt.tech/storage/$path' ,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: path != null
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                        child: AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            titlePadding: EdgeInsets.zero,
                                            title: Container(
                                              width: 220,
                                              height: MediaQuery.sizeOf(context)
                                                      .height -
                                                  350,
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 10,
                                                        spreadRadius: 2,
                                                        offset: Offset(5, 5))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        'https://palmail.gsgtt.tech/storage/$path',
                                                      ))),
                                            )),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : const Text(''),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    return const SizedBox.shrink();
  }

  return GestureDetector(
    onTap: onTap,
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16.0), // Adjust the corner radius as needed
      ),
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: Color(int.parse(mail.status!.color!)),
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(mail.sender!.name ?? 'name'.tr(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Row(
                            children: [
                              Text(formattedDate,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 12,
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mail.subject!,
                                style: const TextStyle(fontSize: 14)),
                            Text(
                              mail.description ?? 'description'.tr(),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xff898989)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            getTags(mail.tags),
                            const SizedBox(
                              height: 5,
                            ),
                            getAttachments(mail.attachments),
                          ],
                        ),
                      ),

                      //
                    ],
                  ),
                ],
              ),
            );
          })),
    ),
  );
}
