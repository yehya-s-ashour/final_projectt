import 'package:final_projectt/Screens/main_screen.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  final String nameOfStatus;
  const StatusScreen({super.key, required this.nameOfStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F6FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffF7F6FF),
        title: Text(
          nameOfStatus,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const MainPage();
            }));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff6589FF),
          ),
        ),
      ),
//body: ,
    );
  }
}
