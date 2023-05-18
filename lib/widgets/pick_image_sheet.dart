import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class PickImageSheet extends StatelessWidget {
  const PickImageSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map> options = [
      {
        'label': local(context).selectFromGallery,
        'icon': MyIcons.gallery,
        'option': PickImageOptions.gallery
      },
      {
        'label': local(context).takeOnCamera,
        'icon': MyIcons.camera,
        'option': PickImageOptions.camera
      },
      {
        'label': local(context).removePhoto,
        'icon': MyIcons.delete,
        'option': PickImageOptions.remove
      }
    ];
    return MyBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          PickImageOption(options[0]),
          const Divider(height: 1),
          PickImageOption(options[1]),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PickImageOption(
              options[2],
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class PickImageOption extends StatelessWidget {
  final Map option;
  final Color? color;
  const PickImageOption(this.option, {Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (option['option'] == PickImageOptions.remove) {
          Navigator.pop(context);
          return;
        }
        await ImagePicker()
            .pickImage(
                source: option['option'] == PickImageOptions.gallery
                    ? ImageSource.gallery
                    : ImageSource.camera,
                preferredCameraDevice: CameraDevice.front)
            .then((pickedFile) {
          File? file;
          if (pickedFile != null) file = File(pickedFile.path);
          Navigator.pop(context, file);
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          option['label'],
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
        ),
      ),
    );
  }
}

enum PickImageOptions { camera, gallery, remove }
