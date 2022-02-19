import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/account/birthday.dart';
import 'package:pulsar/settings/account/category.dart';
import 'package:pulsar/settings/account/change_username.dart';
import 'package:pulsar/settings/account/interests.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/pick_image_sheet.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserProvider provider;
  late User user;

  late String? profilePic;
  MyImageProvider imageProvider = MyImageProvider.network;

  late TextEditingController fullnameController;
  late TextEditingController bioController;
  late TextEditingController portfolioController;

  Interest? category;
  late List<Interest> interests;

  // YYYY-MM-DD
  String? birthday;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<UserProvider>(context, listen: false);
    fullnameController = TextEditingController(text: provider.user.fullname);
    bioController = TextEditingController(text: provider.user.bio);
    portfolioController = TextEditingController(text: provider.user.portfolio);
    interests = provider.user.interests ?? [];
    birthday = provider.user.dateOfBirth?.toString().split(' ')[0];
    profilePic = provider.user.profilePic?.photo(context);
  }

  exit() {
    FocusScope.of(context).unfocus();
    openDialog(
            context,
            (context) => const MyDialog(
                  title: 'Caution!',
                  body: 'The changes that you\'ve made would be lost.',
                  actions: ['Cancel', 'Ok'],
                  destructive: 'Ok',
                ),
            dismissible: true)
        .then((value) {
      if (value == 'Ok') {
        Navigator.pop(context);
      }
    });
  }

  submit() async {
    FocusScope.of(context).unfocus();
    await openDialog(
      context,
      (context) => LoadingDialog(
        () async {
          await provider.editProfile(context,
              category: category?.category,
              bio: bioController.text,
              fullname: fullnameController.text,
              portfolio: portfolioController.text,
              birthday: birthday,
              profilePic: imageProvider == MyImageProvider.file
                  ? File(profilePic!)
                  : null);
          return;
        },
        text: 'Submitting',
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    fullnameController.dispose();
    bioController.dispose();
    portfolioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<UserProvider>(context);
    user = provider.user;
    return WillPopScope(
      onWillPop: () async {
        exit();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(MyIcons.close),
              onPressed: exit,
            ),
            title: const Text('Edit Profile'),
            actions: [MyTextButton(text: 'Update', onPressed: submit)],
          ),
          body: Container(
            color: Theme.of(context).colorScheme.surface,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: kToolbarHeight),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 21),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ProfilePic(
                                profilePic,
                                radius: 75,
                                provider: imageProvider,
                              ),
                              InkWell(
                                onTap: () async {
                                  File? image = await openBottomSheet(
                                      context, (context) => PickImageSheet());
                                  File? croppedImage;
                                  if (image != null) {
                                    croppedImage = await ImageCropper.cropImage(
                                      sourcePath: image.path,
                                      aspectRatio: const CropAspectRatio(
                                          ratioX: 1, ratioY: 1),
                                      cropStyle: CropStyle.circle,
                                    );
                                  }
                                  setState(() {
                                    if (croppedImage != null) {
                                      profilePic = croppedImage.path;
                                      imageProvider = MyImageProvider.file;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  child: Container(
                                    width: 42,
                                    height: 42,
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
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          MyListTile(
                            title: 'Username',
                            onPressed: () {
                              Navigator.of(context).push(myPageRoute(
                                  builder: (context) =>
                                      const ChangeUsername()));
                            },
                            flexRatio: const [2, 3],
                            trailingText: '@${user.username}',
                            trailing: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(MyIcons.edit,
                                  size: 16.5,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .color),
                            ),
                            trailingArrow: false,
                          ),
                          MyListTile(
                              title: 'Full name',
                              flexRatio: const [2, 3],
                              trailingArrow: false,
                              trailing: Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: fullnameController,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'fullname',
                                      hintStyle:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ))),
                          MyListTile(
                              title: 'Bio',
                              flexRatio: const [1, 4],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              trailingArrow: false,
                              trailing: Expanded(
                                  flex: 4,
                                  child: TextField(
                                    controller: bioController,
                                    textAlign: TextAlign.end,
                                    minLines: 1,
                                    maxLines: 3,
                                    maxLength: 80,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Add a bio for your profile',
                                      hintStyle:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ))),
                          MyListTile(
                              title: 'Website',
                              flexRatio: const [2, 3],
                              trailingArrow: false,
                              trailing: Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: portfolioController,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'www.example.com',
                                      hintStyle:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ))),
                        ],
                      )),
                  const SectionTitle(title: 'Additional Information'),
                  MyListTile(
                    title: 'Category',
                    onPressed: () => Navigator.of(context)
                        .push(myPageRoute(
                            builder: (context) =>
                                EditCategory(initialCategory: category)))
                        .then((value) {
                      if (value is Interest) {
                        setState(() {
                          category = value;
                        });
                      }
                    }),
                    subtitle: category?.category ?? user.category,
                  ),
                  MyListTile(
                      title: 'Interests',
                      onPressed: () => Navigator.of(context)
                              .push(myPageRoute(
                                  builder: (context) => EditInterests(
                                      initialInterests: interests)))
                              .then((value) {
                            if (value is List<Interest>) {
                              setState(() {
                                interests = value;
                              });
                            }
                          }),
                      subtitle: interests.isEmpty
                          ? 'None'
                          : "${interests[0].name}${interests.length > 1 ? ', ' + interests[1].name : ''}${interests.length > 2 ? ', +${interests.length - 2}' : ''}"),
                  MyListTile(
                      title: 'Birthday',
                      onPressed: () => Navigator.of(context)
                              .push(myPageRoute(
                                  builder: (context) => EditBirthday(
                                        initialDate:
                                            DateTime.tryParse(birthday ?? ''),
                                      )))
                              .then((value) {
                            if (value is String) {
                              setState(() {
                                birthday = value;
                              });
                            }
                          }),
                      subtitle: birthday == null
                          ? 'None'
                          : timeBirthday(
                                  DateTime.parse(birthday ?? ''))['birthday'] ??
                              'None'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
