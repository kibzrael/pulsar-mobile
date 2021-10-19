import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChooseCategory extends StatefulWidget {
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  late SignInfoProvider provider;

  List<Interest> categories = [
    music,
    art,
    photography,
    comedy,
    dance,
    gymnastics,
    modelling,
    acting,
    interiorDesign,
    makeup,
    magic,
    puppetry
  ];

  Interest? selectedCategory;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: SignInfoTitle(
          title: 'Category',
          onBack: provider.previousPage,
          onForward: () {
            provider.user.category = selectedCategory;
            provider.nextPage();
          },
        )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            height: size,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  alignment: Alignment.center,
                  child: Text(
                    'Who do you consider yourself to be?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: SearchInput(
                      text: 'Category',
                      height: 50,
                    )
                    // MyTextInput(
                    //   hintText: 'Category',
                    //   prefix: Padding(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: Icon(MyIcons.search),
                    //   ),
                    //   onChanged: (text) {},
                    //   onSubmitted: (text) {},
                    // ),
                    ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        Interest category = categories[index];
                        bool selected = category == selectedCategory;
                        return LayoutBuilder(builder: (context, snapshot) {
                          return Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: snapshot.maxWidth,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    image: DecorationImage(
                                        image: AssetImage(category.coverPhoto!),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Spacer(),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    category.name,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                          );
                        });

                        // MyListTile(
                        //   title: category.category,
                        //   onPressed: () {
                        //     setState(() {
                        //       selectedCategory = category;
                        //     });
                        //   },
                        //   leading: CircleAvatar(
                        //       radius: 24,
                        //       backgroundColor: Theme.of(context).dividerColor,
                        //       backgroundImage:
                        //           AssetImage('${category.coverPhoto}')),
                        //   subtitle: '2K users',
                        //   trailingArrow: !selected,
                        //   trailing: selected
                        //       ? CircleAvatar(
                        //           backgroundColor:
                        //               Theme.of(context).colorScheme.secondary,
                        //           radius: 12,
                        //           child: FittedBox(
                        //             fit: BoxFit.scaleDown,
                        //             child: Padding(
                        //               padding: EdgeInsets.all(8.0),
                        //               child: Icon(
                        //                 MyIcons.check,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ),
                        //         )
                        //       : null,
                        // );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
