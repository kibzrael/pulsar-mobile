import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/settings/admin/edit_screen.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/pick_image_sheet.dart';
import 'package:pulsar/widgets/route.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({Key? key}) : super(key: key);

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? name;
  String? cover;

  String description = '';

  create() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Challenge"),
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
        body: Theme(
          data: Theme.of(context),
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        margin: const EdgeInsets.only(bottom: 26),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).textTheme.headline1!.color!,
                                  Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor!
                                ]),
                            image: cover == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(cover!)))),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 30,
                        child: InkWell(
                          onTap: () async {
                            File? image = await openBottomSheet(
                                context, (context) => PickImageSheet());
                            File? croppedImage;
                            if (image != null) {
                              croppedImage = await ImageCropper.cropImage(
                                sourcePath: image.path,
                                aspectRatio: const CropAspectRatio(
                                    ratioX: 16, ratioY: 9),
                                cropStyle: CropStyle.circle,
                              );
                            }
                            setState(() {
                              if (croppedImage != null) {
                                cover = croppedImage.path;
                                // imageProvider = MyImageProvider.file;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  gradient: secondaryGradient(
                                      begin: Alignment.topLeft),
                                  shape: BoxShape.circle),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(
                                  MyIcons.add,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      var value = await Navigator.of(context).push(myPageRoute(
                          builder: (context) => EditScreen(
                              field: "Challenge Name",
                              maxLength: 15,
                              initialText: name)));
                      if (value is String) {
                        setState(() {
                          name = value;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name ?? "Challenge Name",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 21),
                          ),
                          const SizedBox(width: 5),
                          Icon(MyIcons.edit)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: "Description"),
                      maxLength: 80,
                      maxLines: 4,
                      minLines: 1,
                      onChanged: (text) => description = text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: MyListTile(
                      title: "Category",
                      subtitle: 'None',
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: ActionButton(title: "Create", onPressed: create),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
