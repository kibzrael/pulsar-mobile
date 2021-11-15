import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChooseCategory extends StatefulWidget {
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  List<Interest> categories = [];

  Interest? selectedCategory;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    bool isSolo = provider.user.userType == UserType.solo;

    categories = [
      ...provider.interests.where((element) => element.parent == null)
    ];

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
                    'Who do you consider yoursel${isSolo ? 'f' : 'ves'} to be?',
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
                      text: (isSolo
                              ? selectedCategory?.category
                              : selectedCategory?.pCategory ??
                                  selectedCategory?.category) ??
                          'Category',
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
                          crossAxisSpacing: 21,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        Interest category = categories[index];
                        bool selected = category == selectedCategory;
                        return LayoutBuilder(builder: (context, snapshot) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: snapshot.maxWidth,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .inputDecorationTheme
                                              .fillColor,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  category.coverPhoto!),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      if (selected)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            child: Container(
                                              width: 27,
                                              height: 27,
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      colors: [
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primaryVariant
                                                      ])),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Icon(
                                                  MyIcons.check,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  Spacer(),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      isSolo
                                          ? category.category
                                          : category.pCategory ??
                                              category.category,
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
