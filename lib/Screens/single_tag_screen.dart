// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:final_projectt/core/services/tags_controller.dart';
import 'package:final_projectt/core/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/util/constants/colors.dart';
import '../models/mail_model.dart';

class SingleTagScreen extends StatefulWidget {
  int tagId;
  String tagName;
  SingleTagScreen({
    Key? key,
    required this.tagId,
    required this.tagName,
  }) : super(key: key);

  @override
  State<SingleTagScreen> createState() => _SingleTagScreenState();
}

class _SingleTagScreenState extends State<SingleTagScreen> {
  late Future<List<Mail>> mails;
  @override
  void initState() {
    mails = getAllMailsHaveTags([widget.tagId]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text(
          '#${widget.tagName}',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
        centerTitle: true,
        backgroundColor: backGroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 10),
        child: FutureBuilder(
            future: mails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return myCustomCard(
                        snapshot.data![index],
                        () {},
                      );
                    });
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                child: SpinKitPulse(
                  duration: Duration(milliseconds: 1000),
                  color: Colors.grey,
                  size: 40,
                ),
              );
            }),
      ),
    );
  }
}
