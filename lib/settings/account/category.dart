import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/user_provider.dart';
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
  late UserProvider userProvider;

  // user isSolo
  bool isSolo = true;

  List<Interest> categories = [];

  Interest? selectedCategory;

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    selectedCategory = widget.initialCategory;
    fetchInterests();
  }

  fetchInterests() async {
    categories = await userProvider.activeCategories(context);
    setState(() {});
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
