import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  bool isSubmitting = false;

  List<Interest> interests = [];

  List<Interest> selected = [];

  void login() async {
    provider.user.interests = selected;
    setState(() {
      isSubmitting = true;
    });
    await provider.submit();

    setState(() {
      isSubmitting = false;
    });
    Navigator.of(context).pushReplacementNamed('/');
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    interests = [
      ...provider.interests.where((element) => element.parent == null)
    ];

    return Scaffold(
        appBar: signInfoAppBar(
            title: 'Interests',
            onBack: provider.previousPage,
            onForward: login),
        body: ListView.builder(
          itemCount: interests.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Text(
                  'Select the fields you\nare interested in',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 24),
                ),
              );
            }

            Interest interest = interests[index - 1];
            bool isSelected = selected.contains(interest);

            List<Interest> subInterests = provider.interests
                .where((element) => element.parent == interest)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyListTile(
                    title: interest.name,
                    subtitle: '2K posts',
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      backgroundImage:
                          CachedNetworkImageProvider(interest.coverPhoto!),
                    ),
                    trailingArrow: false,
                    trailing: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected)
                            selected.remove(interest);
                          else
                            selected.add(interest);
                        });
                      },
                      child: Card(
                        shape: CircleBorder(),
                        child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient:
                                    isSelected ? primaryGradient() : null),
                            child: Icon(
                                isSelected ? MyIcons.check : MyIcons.add,
                                color: isSelected ? Colors.white : null)),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (int i = 0; i < subInterests.length; i++)
                        Builder(builder: (context) {
                          bool isSelected = selected.contains(subInterests[i]);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected)
                                  selected.remove(subInterests[i]);
                                else
                                  selected.add(subInterests[i]);
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient:
                                        isSelected ? primaryGradient() : null),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(subInterests[i].name,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : null)),
                                    ),
                                    Icon(
                                        isSelected
                                            ? MyIcons.check
                                            : MyIcons.add,
                                        color: isSelected ? Colors.white : null)
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
