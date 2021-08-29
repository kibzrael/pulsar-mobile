import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        children: [
          SizedBox(height: 30),
          Flexible(
            child: ListView.builder(
                itemCount: 12,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return FilterWidget();
                }),
          ),
        ],
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 12),
      padding: EdgeInsets.all(4),
      width: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white12,
            backgroundImage: CachedNetworkImageProvider(beth.profilePic),
          ),
          Text(
            'Filter',
            maxLines: 1,
            style:
                Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: 16.5),
          )
        ],
      ),
    );
  }
}
