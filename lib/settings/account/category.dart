import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/auth/sign_info/seach_category.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditCategory extends StatefulWidget {
  final Interest? initialCategory;

  const EditCategory({Key? key, required this.initialCategory})
      : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  // user isSolo
  bool isSolo = true;

  List<Interest> categories = [];

  Interest? selectedCategory;

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    fetchInterests();
  }

  search() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => const SearchCategory()));
  }

  fetchInterests() async {
    String categoriesJson = await DefaultAssetBundle.of(context)
        .loadString('assets/categories.json');
    var interests = jsonDecode(categoriesJson);
    categories.clear();
    interests.forEach((key, item) {
      Interest interest = Interest(
        name: key,
        category: item['user'],
        pCategory: item['users'],
        coverPhoto: Photo(thumbnail: item['cover']),
      );
      categories.add(interest);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MyIcons.back),
          onPressed: () {
            if (isEdited) {
              openDialog(
                      context,
                      (context) => const MyDialog(
                            title: 'Caution!',
                            body:
                                'The changes you\'ve made would be lost if you quit.',
                            actions: ['Cancel', 'Ok'],
                            destructive: 'Ok',
                          ),
                      dismissible: true)
                  .then((value) {
                if (value == 'Ok') {
                  Navigator.pop(context);
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Category'),
        actions: [
          MyTextButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(context, selectedCategory);
              })
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: constraints.maxHeight,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SearchInput(
                      onPressed: search,
                      text: 'Search Categores',
                      height: 50,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 21,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        Interest category = categories[index];

                        bool selected =
                            category.category == selectedCategory?.category;

                        return LayoutBuilder(builder: (context, snapshot) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isEdited = true;
                                selectedCategory = category;
                              });
                            },
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
                                            image: CachedNetworkImageProvider(
                                                category.coverPhoto!.thumbnail),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (selected)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                          child: Container(
                                            width: 27,
                                            height: 27,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: secondaryGradient(
                                                  begin: Alignment.topLeft),
                                            ),
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
                                const Spacer(),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    isSolo
                                        ? category.category
                                        : category.pCategory ??
                                            category.category,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          );
                        });
                      }),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
