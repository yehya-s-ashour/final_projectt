import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:flutter/material.dart';

//Card myCustomCard(nameofmodel  email) {
Card myCustomCard() {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(16.0), // Adjust the corner radius as needed
    ),
    child: ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: inProgressColor,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text("Organization Name",
                            style: TextStyle(fontSize: 18)),
                        Spacer(),
                        Text("Today, 11:00 AM",
                            style: TextStyle(color: Colors.grey, fontSize: 12))
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Here we add the subject",
                              style: TextStyle(fontSize: 14)),
                          Text(
                            "Your long text that may wrap to the next line and get truncated if it exceeds two lines.next line and get truncated if it exceeds two lines",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff898989)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "#Urgent  #Egyptian Military",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff6589FF)),
                          ),
                        ],
                      ),
                    ),

                    //
                  ],
                ),
              ),
            ],
          );
        })),
  );
}
