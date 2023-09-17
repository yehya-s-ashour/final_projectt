import 'package:final_projectt/core/services/catego_controller.dart';
import 'package:final_projectt/core/util/constants/colors.dart';
import 'package:final_projectt/core/widgets/custom_box.dart';
import 'package:final_projectt/models/catego_model.dart';
import 'package:flutter/material.dart';

class categoriesBottomSheet extends StatefulWidget {
  const categoriesBottomSheet({super.key});

  @override
  State<categoriesBottomSheet> createState() => _categoriesBottomSheetState();
}

class _categoriesBottomSheetState extends State<categoriesBottomSheet> {
  late Future<List<CategoryElement>> categories;
  int selectedIndex = 0;
  late CategoryElement selectedCategory = CategoryElement(
      id: 1,
      name: 'Other',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      sendersCount: '',
      senders: []);

  @override
  void initState() {
    categories = getCatego();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          const Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 15.0, start: 8, end: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.transparent,
                  ),
                ),
                Center(
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 5, start: 5, end: 5),
                    child: CustomWhiteBox(
                      width: 378,
                      height: (snapshot.data!.length) * 55,
                      child: SizedBox(
                        height: 500,
                        child: ListView.builder(
                          padding: EdgeInsetsDirectional.only(top: 5),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      selectedCategory = snapshot.data![index];
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        Navigator.pop(
                                            context, selectedCategory);
                                      });
                                    });
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${snapshot.data![index].name}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Spacer(),
                                          selectedIndex == index
                                              ? Icon(
                                                  Icons.check,
                                                  color: primaryColor,
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            width: 15,
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 1,
                                        color:
                                            snapshot.data!.length - 1 == index
                                                ? Colors.transparent
                                                : Colors.grey.shade300,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: snapshot.data!.length,
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
