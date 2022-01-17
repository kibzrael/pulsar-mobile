import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class PickImageSheet extends StatelessWidget {
  final List<Map> options = [
    {
      'label': 'Select from gallery',
      'icon': MyIcons.gallery,
      'option': PickImageOptions.gallery
    },
    {
      'label': 'Take on camera',
      'icon': MyIcons.camera,
      'option': PickImageOptions.camera
    },
    {
      'label': 'Remove photo',
      'icon': MyIcons.delete,
      'option': PickImageOptions.remove
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          PickImageOption(options[0]),
          Divider(height: 1),
          PickImageOption(options[1]),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 8),
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
  PickImageOption(this.option, {this.color});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (option['option'] == PickImageOptions.remove) {
          Navigator.pop(context);
          return;
        }
        XFile? pickedFile = await ImagePicker().pickImage(
            source: option['option'] == PickImageOptions.gallery
                ? ImageSource.gallery
                : ImageSource.camera,
            preferredCameraDevice: CameraDevice.front);
        File? file;
        if (pickedFile != null) file = File(pickedFile.path);
        Navigator.pop(context, file);
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          option['label'],
          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: color),
        ),
      ),
    );
  }
}

enum PickImageOptions { camera, gallery, remove }
