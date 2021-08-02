import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class PickImageSheet extends StatelessWidget {
  final List<Map> options = [
    {
      'label': 'Gallery',
      'icon': MyIcons.gallery,
      'option': PickImageOptions.gallery
    },
    {
      'label': 'Camera',
      'icon': MyIcons.camera,
      'option': PickImageOptions.camera
    },
    {
      'label': 'Remove',
      'icon': MyIcons.delete,
      'option': PickImageOptions.remove
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [for (Map option in options) PickImageOption(option)],
            ),
          ),
        ],
      ),
    );
  }
}

class PickImageOption extends StatelessWidget {
  final Map option;
  PickImageOption(this.option);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // if (option['option'] == PickImageOptions.remove) {
        //   Navigator.pop(context, PickImageOptions.remove);
        //   return;
        // }
        // PickedFile pickedFile = await ImagePicker().getImage(
        //     source: option['option'] == PickImageOptions.gallery
        //         ? ImageSource.gallery
        //         : ImageSource.camera,
        //     preferredCameraDevice: CameraDevice.front);
        // File file = File(pickedFile.path);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Icon(
              option['icon'],
              size: 42,
            ),
            SizedBox(height: 5),
            Text(
              option['label'],
              style: Theme.of(context).textTheme.headline1,
            )
          ],
        ),
      ),
    );
  }
}

enum PickImageOptions { camera, gallery, remove }
