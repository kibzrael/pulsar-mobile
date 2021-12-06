import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/widgets/action_button.dart';

class IntroduceYourself extends StatefulWidget {
  @override
  _IntroduceYourselfState createState() => _IntroduceYourselfState();
}

class _IntroduceYourselfState extends State<IntroduceYourself> {
  late SignInfoProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double topPadding = MediaQuery.of(context).padding.top;

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> overlays = [
      {'left': 21.0, 'bottom': 21.0, 'size': 30.0},
      {'left': 32.0, 'bottom': deviceHeight / 5, 'size': 60.0},
      {'left': deviceWidth / 1.2, 'bottom': deviceHeight / 2, 'size': 30.0},
    ];

    Widget border({required Widget child}) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).colorScheme.surface, width: 5)),
        child: child,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor:
              Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0)),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Stack(
          children: [
            for (var overlay in overlays)
              Positioned(
                left: overlay['left'],
                bottom: overlay['bottom'],
                child: Container(
                  width: overlay['size'],
                  height: overlay['size'],
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context)
                              .inputDecorationTheme
                              .fillColor!)),
                ),
              ),
            Positioned(
              top: -deviceWidth / 2,
              left: -deviceWidth / 3,
              child: border(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(deviceWidth),
                  child: Container(
                    width: deviceWidth,
                    height: deviceWidth,
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: deviceWidth / 2 - (8 + 5),
                          left: deviceWidth / 3 - (8 + 5)),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/intro/group.jpg'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -deviceWidth / 2.4,
              right: -deviceWidth / 2.4,
              child: border(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(deviceWidth),
                  child: Container(
                    width: deviceWidth,
                    height: deviceWidth,
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: deviceWidth / 2.4 - (8 + 5),
                          right: deviceWidth / 2.4 - (8 + 5)),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/intro/solo.jpg'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Introduce\nYourself',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 48),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: ActionButton(
                        title: 'Solo',
                        onPressed: () {
                          provider.user.userType = UserType.solo;
                          provider.nextPage();
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: ActionButton(
                        title: 'Group',
                        onPressed: () {
                          provider.user.userType = UserType.group;
                          provider.nextPage();
                        },
                        backgroundColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        titleColor:
                            Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
