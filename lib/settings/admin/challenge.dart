import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/admin/edit_screen.dart';
import 'package:pulsar/urls/challenge.dart';
import 'package:pulsar/urls/get_url.dart';
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

  late UserProvider userProvider;

  List<Interest>? get categories => userProvider.categories;

  String? name;
  String? cover;

  late TextEditingController descriptionController;
  String description = '';

  Interest? category;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
  }

  create() async {
    if (name == null ||
        cover == null ||
        category == null ||
        description == '') {
      Fluttertoast.showToast(msg: "Please enter all values");
      return;
    }
    isSubmitting = true;
    if (mounted) setState(() {});
    File? resizedCover;
    img.Image? image = img.decodeImage(File(cover!).readAsBytesSync());
    if (image != null) {
      img.Image resized = img.copyResize(image, width: 480);
      String identifier = '${DateTime.now()}'.replaceAll('.', '');
      Directory dir = await getTemporaryDirectory();
      resizedCover = await File(join(dir.path, '$identifier.jpg'))
          .writeAsBytes(img.encodeJpg(resized));
    }

    if (resizedCover == null) {
      Fluttertoast.showToast(msg: "Error resizing the image");
      return;
    }

    String url = getUrl(ChallengeUrls.createChallenge);

    Dio dio = Dio();
    FormData form = FormData.fromMap({
      'category': category!.name,
      'name': name,
      'description': description,
      'cover': await MultipartFile.fromFile(resizedCover.path,
          filename: 'cover.jpg',
          contentType: parser.MediaType('image', 'jpeg')),
    });

    try {
      Response response = await dio.post(
        url,
        options: Options(headers: {
          'Authorization': userProvider.user.token ?? '',
          "Content-type": "multipart/form-data",
        }),
        data: form,
        onSendProgress: (int sent, int total) {
          debugPrint("sent${sent.toString()} total${total.toString()}");
        },
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Challenge created Successful");
        name = null;
        cover = null;
        description = '';
        descriptionController.text = '';
        category = null;
        setState(() {});
      } else {
        if (response.data is Map) {
          Fluttertoast.showToast(
              msg: response.data['message'] ?? 'Unknown Error');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    isSubmitting = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
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
                                  Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color!,
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
                            CroppedFile? croppedImage;
                            if (image != null) {
                              croppedImage = await ImageCropper().cropImage(
                                sourcePath: image.path,
                                aspectRatio:
                                    const CropAspectRatio(ratioX: 4, ratioY: 3),
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
                                  gradient: accentGradient(),
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
                              maxLength: 24,
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
                                .bodyLarge!
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
                      controller: descriptionController,
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
                      child: DropdownButton(
                          value: category?.name,
                          hint: const Text("Challenge Category"),
                          items: categories
                              ?.map((e) => DropdownMenuItem(
                                  value: e.name, child: Text(e.name)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              category = categories?.firstWhere(
                                  (element) => element.name == value);
                            });
                          })
                      // MyListTile(
                      //   title: "Category",
                      //   subtitle: 'None',
                      //   onPressed: () {},
                      // ),
                      ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: AuthButton(
                          title: 'Create',
                          onPressed: create,
                          isSubmitting: isSubmitting))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
