import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_interests.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditInterests extends StatefulWidget {
  final List<Interest> initialInterests;

  const EditInterests({Key? key, required this.initialInterests})
      : super(key: key);

  @override
  State<EditInterests> createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  late UserProvider userProvider;

  List<Interest> interests = [];
  List<Interest> selected = [];

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    selected = [...widget.initialInterests];
    fetchInterests();
  }

  fetchInterests() async {
    interests = await userProvider.activeCategories(context);
    setState(() {});
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
