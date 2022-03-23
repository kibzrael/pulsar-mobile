import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/settings/admin/edit_screen.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/pick_image_sheet.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({Key? key}) : super(key: key);

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? name;

  String? user;
  String? users;

  String? cover;

  Interest? parent;

  create() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                15, 30, 15, MediaQuery.of(context).padding.bottom),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ProfilePic(cover,
                        radius: constraints.maxWidth / 4,
                        provider: MyImageProvider.file),
                    InkWell(
                      onTap: () async {
                        File? image = await openBottomSheet(
                            context, (context) => PickImageSheet());
                        File? croppedImage;
                        if (image != null) {
                          croppedImage = await ImageCropper.cropImage(
                            sourcePath: image.path,
                            aspectRatio:
                                const CropAspectRatio(ratioX: 1, ratioY: 1),
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
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              gradient:
                                  secondaryGradient(begin: Alignment.topLeft),
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
                  ],
                ),
                InkWell(
                  onTap: () async {
                    var value = await Navigator.of(context).push(myPageRoute(
                        builder: (context) => EditScreen(
                            field: "Category Name",
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name ?? "Category Name",
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
                MyListTile(
                  title: 'User',
                  subtitle: user ?? "None",
                  onPressed: () async {
                    var value = await Navigator.of(context).push(myPageRoute(
                        builder: (context) => EditScreen(
                            field: "Category User",
                            maxLength: 15,
                            initialText: name)));
                    if (value is String) {
                      setState(() {
                        user = value;
                      });
                    }
                  },
                ),
                MyListTile(
                  title: 'Users',
                  subtitle: users ?? 'None',
                  onPressed: () async {
                    var value = await Navigator.of(context).push(myPageRoute(
                        builder: (context) => EditScreen(
                            field: "Category Users",
                            maxLength: 15,
                            initialText: name)));
                    if (value is String) {
                      setState(() {
                        users = value;
                      });
                    }
                  },
                ),
                MyListTile(
                  title: 'Parent',
                  subtitle: parent?.name ?? 'None',
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ActionButton(
                    title: 'Create',
                    onPressed: create,
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
