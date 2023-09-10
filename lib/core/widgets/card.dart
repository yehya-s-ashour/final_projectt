import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/mail_model.dart';

Widget myCustomCard(Mails mail) {
  String dateTimeString = mail.archiveDate!;
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('yyyy  MMM  dd').format(dateTime);

  Text getTags(List<Tags>? tags) {
    String tag = '';
    if (tags != []) {
      for (int i = 0; i < tags!.length; i++) {
        tag = '#${tags[i].name}';
      }
      return Text(
        tag,
        style: const TextStyle(
            fontSize: 14,
            color: Color(0xff6589FF),
            fontWeight: FontWeight.w400),
      );
    }
    return const Text('');
  }

  Widget getAttachments(List<Attachments>? attach) {
    String? path;
    if (attach != []) {
      for (int i = 0; i < attach!.length; i++) {
        path = '${attach[i].image}';
      }
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
              ? Image.network(
                  'https://palmail.gsgtt.tech/storage/$path',
                  fit: BoxFit.fill,
                )
              : const Text(''),
        ),
      );
    }
    return const Text('');
  }

  return GestureDetector(
    onTap: () {},
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
                                color: int.parse(mail.statusId!) == 1
                                    ? inboxColor
                                    : int.parse(mail.statusId!) == 2
                                        ? pendingColor
                                        : int.parse(mail.statusId!) == 3
                                            ? inProgressColor
                                            : completedColor,
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
