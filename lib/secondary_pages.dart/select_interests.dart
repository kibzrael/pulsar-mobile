import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class SelectInterests extends StatefulWidget {
  final List<Interest> initialInterests;
  final List<Interest> interests;
  final Function(List<Interest> selectedInterests) onSelect;
  const SelectInterests(
      {Key? key,
      required this.initialInterests,
      required this.interests,
      required this.onSelect})
      : super(key: key);

  @override
  _SelectInterestsState createState() => _SelectInterestsState();
}

class _SelectInterestsState extends State<SelectInterests>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Interest> interests = [];
  List<Interest> selected = [];

  @override
  void initState() {
    super.initState();
    selected = [...widget.initialInterests];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    interests = [...widget.interests];
    List<Interest> majorInterests = [
      ...interests.where((element) => element.parent == null)
    ];

    return ListView.builder(
      itemCount: majorInterests.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Text(
              'Select the fields you\nare interested in',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),
            ),
          );
        }

        Interest interest = majorInterests[index - 1];
        bool isSelected =
            selected.any((element) => element.name == interest.name);

        List<Interest> subInterests =
            interests.where((element) => element.parent == interest).toList();

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
                  backgroundImage: CachedNetworkImageProvider(
                      interest.coverPhoto!.thumbnail),
                ),
                trailingArrow: false,
                trailing: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selected.removeWhere(
                            (element) => element.name == interest.name);
                      } else {
                        selected.add(interest);
                      }
                    });
                    widget.onSelect(selected);
                  },
                  child: Card(
                    shape: const CircleBorder(),
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isSelected ? primaryGradient() : null),
                        child: Icon(isSelected ? MyIcons.check : MyIcons.add,
                            color: isSelected ? Colors.white : null)),
                  ),
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (int i = 0; i < subInterests.length; i++)
                    Builder(builder: (context) {
                      bool isSelected = selected.any(
                          (element) => element.name == subInterests[i].name);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selected.removeWhere((element) =>
                                  element.name == subInterests[i].name);
                            } else {
                              selected.add(subInterests[i]);
                            }
                          });
                          widget.onSelect(selected);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient:
                                    isSelected ? primaryGradient() : null),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(subInterests[i].name,
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : null)),
                                ),
                                Icon(isSelected ? MyIcons.check : MyIcons.add,
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
    );
  }
}
