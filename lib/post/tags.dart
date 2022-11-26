import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_interests.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/widgets/text_button.dart';

class SeletectTags extends StatefulWidget {
  final List<Interest> initialInterests;

  const SeletectTags({Key? key, required this.initialInterests})
      : super(key: key);

  @override
  _SeletectTagsState createState() => _SeletectTagsState();
}

class _SeletectTagsState extends State<SeletectTags> {
  List<Interest> interests = [];
  List<Interest> selected = [];

  @override
  void initState() {
    super.initState();
    selected = [...widget.initialInterests];
    fetchInterests();
  }

  fetchInterests() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

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
        body: Column(
          children: [
            Section(
              title: 'Tag',
              trailing: InkWell(
                  onTap: () => setState(() => selected.clear()),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(MyIcons.clearAll),
                  )),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 35),
                height: 35,
                margin: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.centerLeft,
                child: selected.isEmpty
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'Select tags for your post...',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontSize: 18),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: selected.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Chip(
                              elevation: 1,
                              label: Text('@${selected[index].name}'),
                              backgroundColor: Theme.of(context).cardColor,
                              deleteIcon: ShaderMask(
                                  shaderCallback: (rect) =>
                                      accentGradient().createShader(rect),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  )),
                              onDeleted: () {
                                setState(() {
                                  selected.removeAt(index);
                                });
                              },
                            ),
                          );
                        }),
              ),
            ),
            Expanded(
              child: SelectInterests(
                  initialInterests: widget.initialInterests,
                  interests: interests,
                  selected: selected,
                  title: false,
                  max: 5,
                  onSelect: (selectedInterests) {
                    setState(() {
                      selected = [...selectedInterests];
                    });
                  }),
            ),
          ],
        ));
  }
}
