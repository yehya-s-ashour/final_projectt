import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              return Text(
                tag,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff6589FF),
                    fontWeight: FontWeight.w400),
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
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
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
                                              boxShadow: [
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
                          child: Image.network(
                            'https://palmail.gsgtt.tech/storage/$path',
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Text(''),
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
                          Text(mail.sender!.name ?? 'name',
                              style: const TextStyle(fontSize: 18)),
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
                              mail.description ?? 'description',
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
