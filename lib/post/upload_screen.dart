import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/widgets/text_button.dart';

class UploadScreen extends StatefulWidget {
  final String caption;
  UploadScreen({required this.caption});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late PostProvider provider;

  late TextEditingController captionController;

  bool location = false;

  @override
  void initState() {
    super.initState();
    captionController = TextEditingController(text: widget.caption);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PostProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            MyTextButton(
                text: 'Upload',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                })
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                ),
                                child: Icon(MyIcons.play),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 21,
                                          backgroundColor: Theme.of(context)
                                              .inputDecorationTheme
                                              .fillColor,
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '@username',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            Text(
                                              'Category',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            MyIcons.tag,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            provider.challenge?.name ??
                                                'Challenge',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                        ),
                                        TraillingArrow(size: 15)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Caption',
                                counterText: '${80 - provider.caption.length}'),
                            maxLength: 80,
                            maxLines: 4,
                            minLines: 1,
                            controller: captionController,
                            onChanged: (text) {
                              setState(() {
                                provider.caption = text;
                              });
                            },
                          ),
                        ),
                        MyListTile(
                          title: 'Location',
                          subtitle: 'LA, California',
                          trailingArrow: false,
                          trailing: Switch.adaptive(
                              value: provider.location,
                              onChanged: (value) {
                                setState(() {
                                  provider.location = value;
                                });
                              }),
                        ),
                        MyListTile(
                          title: 'Allow Comments',
                          subtitle: 'Allow all',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Section(
                      title: 'Linked Accounts',
                      child: Column(children: [
                        MyListTile(
                          title: 'Facebook',
                          leading: Icon(MyIcons.facebook, size: 28),
                          subtitle: '@kibzrael',
                        ),
                        MyListTile(
                          title: 'Google',
                          leading: Icon(MyIcons.google, size: 28),
                          subtitle: '@kibzrael',
                        ),
                        MyListTile(
                          title: 'Twitter',
                          leading: Icon(MyIcons.twitter, size: 28),
                          subtitle: '@kibzrael',
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
