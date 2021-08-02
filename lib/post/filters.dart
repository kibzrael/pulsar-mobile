import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
        child: Container(
      height: 120,
      child: ListView.builder(
          itemCount: 12,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return FilterWidget();
          }),
    ));
  }
}

class FilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 12),
      child: Container(
        padding: EdgeInsets.all(4),
        width: 90,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).dividerColor,
              backgroundImage: AssetImage('assets/users/beth.jpg'),
            ),
            Text(
              'Filter',
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(fontSize: 16.5),
            )
          ],
        ),
      ),
    );
  }
}
