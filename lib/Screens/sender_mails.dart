import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:final_projectt/core/widgets/edit_mail_bottom_sheet.dart';
import 'package:final_projectt/models/mail_model.dart';
import 'package:final_projectt/models/sender_model.dart';
import 'package:final_projectt/providers/new_inbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SenderMails extends StatefulWidget {
  SingleSender? sender;
  SenderMails({required this.sender});

  @override
  State<SenderMails> createState() => _SenderMailsState();
}

class _SenderMailsState extends State<SenderMails> {
  SingleSender? sender;

  @override
  void initState() {
    sender = widget.sender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 40, start: 15, end: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primaryColor,
                  ),
                ),
                Text(
                  '${sender!.name} mails',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: int.parse(sender!.mailsCount!),
              itemBuilder: (context, index) {
                Mail mail = Mail(
                  activities: sender!.mails![index].activities,
                  archiveDate: sender!.mails![index].archiveDate,
                  archiveNumber: sender!.mails![index].archiveNumber,
                  attachments: sender!.mails![index].attachments,
                  createdAt: sender!.mails![index].createdAt,
                  decision: sender!.mails![index].decision,
                  description: sender!.mails![index].description,
                  finalDecision: sender!.mails![index].finalDecision,
                  id: sender!.mails![index].id,
                  sender: sender!.mails![index].sender,
                  senderId: sender!.mails![index].senderId,
                  status: sender!.mails![index].status,
                  statusId: sender!.mails![index].statusId,
                  subject: sender!.mails![index].subject,
                  tags: sender!.mails![index].tags!.map((tag) {
                    return MailTag(
                      id: tag.id,
                      name: tag.name,
                      createdAt: tag.createdAt,
                      updatedAt: tag.updatedAt,
                    );
                  }).toList(),
                  updatedAt: sender!.mails![index].updatedAt,
                );
                return ListTile(
                  title: myCustomCard(mail, () {
                    showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      isScrollControlled: true,
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      )),
                      builder: (BuildContext context) {
                        return EditMailBottomSheet(
                          mail: mail,
                          backScreen: '${sender!.name} mails',
                        );
                      },
                    ).whenComplete(
                      () {
                        setState(() {
                          Provider.of<NewInboxProvider>(context, listen: false)
                              .clearImages();

                          Provider.of<NewInboxProvider>(context, listen: false)
                              .activites = [];

                          Provider.of<NewInboxProvider>(context, listen: false)
                              .deletedImages = [];
                        });
                      },
                    );
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
