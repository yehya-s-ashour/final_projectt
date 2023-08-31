import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isdraweropen ? 20 : 0),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isdraweropen
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            xoffset = 0;
                            yoffset = 0;
                            scalefactor = 1;
                            isdraweropen = false;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios))
                    : IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            xoffset = 320;
                            yoffset = 90;
                            // the next line mean: home screen should be 80% of the screen before
                            scalefactor = 0.8;
                            isdraweropen = true;
                          });
                        },
                      ),
                const CircleAvatar(
                  backgroundImage: AssetImage('images/person.jpg'),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
