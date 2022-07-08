import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/pick_image_sheet.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  String? profilePic;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    Widget border({required Widget child}) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).colorScheme.surface, width: 5)),
        child: child,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: signInfoAppBar(
          title: 'Profile Photo',
          onBack: provider.previousPage,
          onForward: () {
            if (profilePic != null) provider.user.profilePic = profilePic;
            provider.nextPage();
          }),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            left: -deviceWidth / 4,
            child: border(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceWidth),
                child: Container(
                  width: deviceWidth / 2,
                  height: deviceWidth / 2,
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  child: Container(
                    margin: EdgeInsets.only(left: deviceWidth / 4 - (8 + 5)),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/intro/profile 1.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: deviceHeight / 6,
            left: -deviceWidth / 5,
            child: border(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceWidth),
                child: Container(
                  width: deviceWidth / 2.5,
                  height: deviceWidth / 2.5,
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  child: Container(
                    margin: EdgeInsets.only(left: deviceWidth / 5 - (8 + 5)),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/intro/profile 4.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: deviceHeight / 4,
            right: -deviceWidth / 6,
            child: border(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceWidth),
                child: Container(
                  width: deviceWidth / 2.5,
                  height: deviceWidth / 2.5,
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  child: Container(
                    margin: EdgeInsets.only(right: deviceWidth / 6 - (8 + 5)),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/intro/profile 3.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -deviceWidth / 2,
            right: -deviceWidth / 2,
            child: border(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(deviceWidth),
                child: Container(
                  width: deviceWidth,
                  height: deviceWidth,
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: deviceWidth / 2 - (8 + 5),
                        right: deviceWidth / 2 - (8 + 5)),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/intro/profile 6.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: deviceWidth / 5 + 50,
            bottom: deviceHeight / 5,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                      image: AssetImage('assets/intro/profile 5.jpg'),
                      fit: BoxFit.cover),
                  border: Border.all(color: Theme.of(context).dividerColor)),
            ),
          ),
          Positioned(
            left: deviceWidth / 2 - 30,
            top: deviceHeight / 5,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                      image: AssetImage('assets/intro/profile 2.jpg'),
                      fit: BoxFit.cover),
                  border: Border.all(color: Theme.of(context).dividerColor)),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ProfilePic(profilePic,
                    radius: 75, provider: MyImageProvider.file),
                InkWell(
                  onTap: () async {
                    File? image = await openBottomSheet(
                        context, (context) => PickImageSheet());
                    CroppedFile? croppedImage;
                    if (image != null) {
                      croppedImage = await ImageCropper().cropImage(
                        sourcePath: image.path,
                        aspectRatio:
                            const CropAspectRatio(ratioX: 1, ratioY: 1),
                        cropStyle: CropStyle.circle,
                      );
                    }
                    setState(() {
                      profilePic = croppedImage?.path;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, gradient: accentGradient()),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Icon(
                            MyIcons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
