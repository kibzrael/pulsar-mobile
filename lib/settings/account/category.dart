import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/secondary_pages.dart/select_category.dart';
import 'package:pulsar/widgets/dialog.dart';
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
        body: SelectCategory(
            categories: categories,
            selectedCategory: selectedCategory,
            isSolo: isSolo,
            onSelect: (category) {
              setState(() {
                isEdited = true;
                selectedCategory = category;
              });
            }));
  }
}
