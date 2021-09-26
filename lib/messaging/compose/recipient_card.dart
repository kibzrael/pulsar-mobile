import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class RecipientCard extends StatelessWidget {
  final User receipient;
  final bool isSelected;
  RecipientCard(this.receipient, {this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return MyListTile(
      title: '@${receipient.username}',
      subtitle: receipient.category,
      leading: ProfilePic(
        receipient.profilePic,
        radius: 27,
      ),
      trailingArrow: false,
      trailing: Container(
        height: 20,
        width: 20,
        child: isSelected
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  MyIcons.check,
                  color: Colors.white,
                  size: 12,
                ),
              )
            : null,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            border: Border.all(
                width: 3,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).dividerColor)),
      ),
    );

    // Container(
    //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       CircleAvatar(
    //         radius: 24,
    //         backgroundColor: Theme.of(context).dividerColor,
    //       ),
    //       Expanded(
    //         child: Container(
    //           margin: EdgeInsets.only(left: 12),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               Text(
    //                 'Full name',
    //                 overflow: TextOverflow.ellipsis,
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .subtitle1!
    //                     .copyWith(fontSize: 16.5),
    //               ),
    //               SizedBox(height: 5),
    //               Text('@username',
    //                   style: Theme.of(context).textTheme.subtitle2)
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         height: 20,
    //         width: 20,
    //         child: widget.isSelected
    //             ? Icon(
    //                 MyIcons.check,
    //                 color: Colors.white,
    //                 size: 12,
    //               )
    //             : null,
    //         decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: widget.isSelected
    //                 ? Theme.of(context).accentColor
    //                 : Colors.transparent,
    //             border: Border.all(
    //                 width: 3,
    //                 color: widget.isSelected
    //                     ? Theme.of(context).accentColor
    //                     : Theme.of(context).dividerColor)),
    //       )
    //     ],
    //   ),
    // );
  }
}
