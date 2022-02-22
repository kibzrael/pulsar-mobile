import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/secondary_pages.dart/select_interests.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditInterests extends StatefulWidget {
  final List<Interest> initialInterests;

  const EditInterests({Key? key, required this.initialInterests})
      : super(key: key);

  @override
  _EditInterestsState createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  List<Interest> interests = [];
  List<Interest> selected = [];

  @override
  void initState() {
    super.initState();
    selected = [...widget.initialInterests];
    fetchInterests();
  }

  fetchInterests() async {
    String categoriesJson = await DefaultAssetBundle.of(context)
        .loadString('assets/categories.json');
    var categories = jsonDecode(categoriesJson);
    interests.clear();
    categories.forEach((key, item) {
      Interest interest = Interest(
        name: key,
        category: item['user'],
        pCategory: item['users'],
        coverPhoto: Photo(thumbnail: item['cover']),
      );
      interests.add(interest);
      setState(() {});
      Map<String, dynamic>? subcategories = item['subcategories'];
      if (subcategories != null) {
        subcategories.forEach((key, item) {
          interests.add(
            Interest(
                name: key,
                category: item['user'] ?? interest.category,
                pCategory: item['users'] ?? interest.pCategory,
                coverPhoto: item['cover'] != null
                    ? Photo(thumbnail: item['cover'])
                    : interest.coverPhoto,
                parent: interest),
          );
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(MyIcons.back),
            onPressed: () {
              bool isEdited = selected.any((element) =>
                      widget.initialInterests.indexWhere((initialElement) =>
                          initialElement.name == element.name) <
                      0) ||
                  widget.initialInterests.any((initialElement) =>
                      selected.indexWhere(
                          (element) => initialElement.name == element.name) <
                      0);
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
          title: const Text('Interests'),
          actions: [
            MyTextButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pop(context, selected);
                })
          ],
        ),
        body: SelectInterests(
            initialInterests: widget.initialInterests,
            interests: interests,
            onSelect: (selectedInterests) {
              setState(() {
                selected = [...selectedInterests];
              });
            }));
  }
}
