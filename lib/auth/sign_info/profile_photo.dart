import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/widgets/pick_image_sheet.dart';

class ProfilePhoto extends StatefulWidget {
  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  late SignInfoProvider provider;

  String? profilePic;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(MyIcons.back),
            onPressed: () {
              provider.previousPage();
            }),
        title: Text('Profile Photo'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).buttonColor,
        onPressed: () {
          provider.user.profilePic = profilePic;
          provider.nextPage();
        },
        child: Icon(MyIcons.forward, size: 30),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          height: size,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Select a profile photo for your account.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Spacer(flex: 1),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                      radius: 75,
                      backgroundColor: Theme.of(context).dividerColor,
                      child:
                          Icon(MyIcons.account, color: Colors.white, size: 90)),
                  InkWell(
                    onTap: () {
                      openBottomSheet(context, (context) => PickImageSheet());
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: Theme.of(context).accentColor,
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
              SizedBox(height: 12),
              Text(
                'Full name',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 24),
              ),
              SizedBox(height: 3),
              Text(
                'Personal Account',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 21),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
