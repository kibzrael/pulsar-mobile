import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/list_tile.dart';
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
    List<Interest> majorInterests = [
      ...interests.where((element) => element.parent == null)
    ];
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
        body: ListView.builder(
          itemCount: majorInterests.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Text(
                  'Select the fields you\nare interested in',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 24),
                ),
              );
            }

            Interest interest = majorInterests[index - 1];
            bool isSelected =
                selected.any((element) => element.name == interest.name);

            List<Interest> subInterests = interests
                .where((element) => element.parent == interest)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyListTile(
                    title: interest.name,
                    subtitle: '2K posts',
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      backgroundImage: CachedNetworkImageProvider(
                          interest.coverPhoto!.thumbnail),
                    ),
                    trailingArrow: false,
                    trailing: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selected.removeWhere(
                                (element) => element.name == interest.name);
                          } else {
                            selected.add(interest);
                          }
                        });
                      },
                      child: Card(
                        shape: const CircleBorder(),
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient:
                                    isSelected ? primaryGradient() : null),
                            child: Icon(
                                isSelected ? MyIcons.check : MyIcons.add,
                                color: isSelected ? Colors.white : null)),
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (int i = 0; i < subInterests.length; i++)
                        Builder(builder: (context) {
                          bool isSelected = selected.any((element) =>
                              element.name == subInterests[i].name);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selected.removeWhere((element) =>
                                      element.name == subInterests[i].name);
                                } else {
                                  selected.add(subInterests[i]);
                                }
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient:
                                        isSelected ? primaryGradient() : null),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(subInterests[i].name,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : null)),
                                    ),
                                    Icon(
                                        isSelected
                                            ? MyIcons.check
                                            : MyIcons.add,
                                        color: isSelected ? Colors.white : null)
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
