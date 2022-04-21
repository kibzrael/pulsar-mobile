import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/post/post_preview.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/tags.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';

class UploadScreen extends StatefulWidget {
  final String caption;
  const UploadScreen({Key? key, required this.caption}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late PostProvider provider;

  late SocialTextEditingController captionController;
  late TextEditingController tagController;

  bool location = false;

  @override
  void initState() {
    super.initState();
    captionController = SocialTextEditingController()..text = widget.caption;
    tagController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PostProvider>(context);
    captionController.setTextStyle(DetectedType.hashtag,
        Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue));
    captionController.setTextStyle(DetectedType.mention,
        Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue));
    captionController.setTextStyle(DetectedType.url,
        Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                  myPageRoute(
                                      builder: (context) =>
                                          PostPreview(provider))),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ColorFiltered(
                                    colorFilter: ColorFilter.matrix(
                                        provider.filter.convolution),
                                    child: Container(
                                      width: 120,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Theme.of(context)
                                              .inputDecorationTheme
                                              .fillColor,
                                          image: DecorationImage(
                                              image: MemoryImage(provider
                                                  .thumbnail.thumbnail!),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 12,
                                    child: Text(
                                      'Preview',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: DetectableTextField(
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                hintText: 'Caption...',
                                              ),
                                              maxLength: 80,
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              basicStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(fontSize: 16.5),
                                              controller: captionController,
                                              onChanged: (text) {
                                                setState(() {
                                                  provider.caption = text;
                                                });
                                              },
                                              onDetectionTyped: (detection) {
                                                debugPrint(detection);
                                              },
                                              detectionRegExp:
                                                  detectionRegExp()!,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '# Hashtag',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(fontSize: 16.5),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  '@ Person',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(fontSize: 16.5),
                                                ),
                                              ],
                                            ),
                                          )
                                        ])))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    MyListTile(
                        title: 'Tags',
                        onPressed: () => Navigator.of(context)
                                .push(myPageRoute(
                                    builder: (context) => SeletectTags(
                                        initialInterests: provider.tags)))
                                .then((value) {
                              if (value is List<Interest>) {
                                setState(() {
                                  provider.tags = [...value];
                                });
                              }
                            }),
                        subtitle: provider.tags.isEmpty
                            ? 'None'
                            : "${provider.tags[0].name}${provider.tags.length > 1 ? ', ' + provider.tags[1].name : ''}${provider.tags.length > 2 ? ', +${provider.tags.length - 2}' : ''}"),
                    MyListTile(
                      title: 'Challenge',
                      trailingText: provider.challenge?.name ?? 'None',
                      flexRatio: const [2, 3],
                    ),
                    MyListTile(
                      title: 'Allow Comments',
                      // subtitle: 'Allow all',
                      trailingArrow: false,
                      trailing: Switch.adaptive(
                          value: provider.allowcomments,
                          onChanged: (value) {
                            provider.allowcomments = value;
                            provider.notify();
                          }),
                    ),
                    MyListTile(
                      title: 'Save video on Device',
                      trailingArrow: false,
                      trailing: Switch.adaptive(
                          value: provider.save,
                          onChanged: (value) {
                            provider.save = value;
                            provider.notify();
                          }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(
                          child: ActionButton(
                            title: 'Draft',
                            backgroundColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            onPressed: () {
                              toastNotImplemented();
                            },
                            titleColor:
                                Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: ActionButton(
                              title: 'Post',
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                provider.upload(context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

Map<int, String> allowComments = {
  0: 'Allow all',
  1: 'Allow users you follow',
  2: 'Turn off comments',
};
