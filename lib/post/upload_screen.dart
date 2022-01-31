import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/tag_text.dart';

class UploadScreen extends StatefulWidget {
  final String caption;
  UploadScreen({required this.caption});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late PostProvider provider;

  late TextEditingController captionController;
  late TextEditingController tagController;

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
          title: Text('Upload'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    // Container(
                    //   margin:
                    //       EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         width: 120,
                    //         height: 150,
                    //         alignment: Alignment.bottomCenter,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             color: Theme.of(context)
                    //                 .inputDecorationTheme
                    //                 .fillColor,
                    //             image: DecorationImage(
                    //                 image: AssetImage('assets/intro/solo.jpg'),
                    //                 fit: BoxFit.cover)),
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(vertical: 12),
                    //           child: Text(
                    //             'Preview',
                    //             style: TextStyle(
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 15),
                    //       Expanded(
                    //         child: Padding(
                    //           padding: EdgeInsets.symmetric(vertical: 8),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Flexible(
                    //                 child: TextField(
                    //                   decoration: InputDecoration.collapsed(
                    //                     hintText: 'Caption...',
                    //                   ),
                    //                   maxLength: 80,
                    //                   maxLines: 4,
                    //                   controller: captionController,
                    //                   onChanged: (text) {
                    //                     setState(() {
                    //                       provider.caption = text;
                    //                     });
                    //                   },
                    //                 ),
                    //               ),
                    //               SizedBox(height: 12),
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Text(
                    //                     '# Tag',
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .subtitle2!
                    //                         .copyWith(fontSize: 16.5),
                    //                   ),
                    //                   Text(
                    //                     '@ Person',
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .subtitle2!
                    //                         .copyWith(fontSize: 16.5),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ExtendedTextField(
                          controller: tagController,
                          decoration: InputDecoration(
                              hintText: 'Tags',
                              helperMaxLines: 5,
                              helperText:
                                  'Tag your post to a category to give an idea of what the post is about. This will help with distrubution of your post to the appropriate audience.'),
                          maxLines: 3,
                          minLines: 1,
                          specialTextSpanBuilder: TagTextBuilder(context,
                              controller: tagController),
                        )
                        // TextField(
                        //   decoration: InputDecoration(
                        //       hintText: 'Tags',
                        //       helperMaxLines: 5,
                        //       helperText:
                        //           'Tag your post to a category to give an idea of what the post is about. This will help with distrubution of your post to the appropriate audience.'),
                        //   maxLines: 3,
                        //   minLines: 1,
                        // ),
                        ),
                    SizedBox(height: 12),
                    MyListTile(
                      title: 'Challenge',
                      trailingText: provider.challenge?.name ?? 'None',
                      flexRatio: [2, 3],
                    ),
                    MyListTile(
                      title: 'Allow Comments',
                      subtitle: 'Allow all',
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(
                          child: ActionButton(
                            title: 'Draft',
                            backgroundColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            titleColor:
                                Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        SizedBox(width: 15),
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
