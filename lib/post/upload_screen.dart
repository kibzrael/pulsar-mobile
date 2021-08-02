import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/text_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MyTextButton(
              text: 'Upload',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      child: Icon(MyIcons.play),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@username',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    'Category',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Container(
                                width: 42,
                                alignment: Alignment.center,
                                child: Icon(
                                  MyIcons.tag,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Challenge',
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              TraillingArrow(size: 15)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              MyListTile(
                title: 'Location',
                subtitle: 'LA, California',
              ),
              MyListTile(
                title: 'Allow Comments',
                subtitle: 'Allow all',
              )
            ],
          ),
        ),
      ),
    );
  }
}
