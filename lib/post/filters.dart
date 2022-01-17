import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class Filters extends StatefulWidget {
  final PostProvider postProvider;
  Filters(this.postProvider);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<Filter> filters = [
    original,
    pop,
    grayscale,
    warm,
    cool,
    natural,
    vintage,
    rise,
    bw,
    landscape,
    lofi
  ];

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Container(
        height: 100,
        child: ListView.builder(
            itemCount: filters.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (context, index) {
              return FilterWidget(filters[index]);
            }),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final Filter filter;
  FilterWidget(this.filter);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
      padding: EdgeInsets.all(4),
      width: 90,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white12,
            backgroundImage: CachedNetworkImageProvider(beth.profilePic!),
          ),
          SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              filter.name,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(fontSize: 16.5),
            ),
          )
        ],
      ),
    );
  }
}

class Filter {
  String name;

  Filter(this.name);
}

Filter original = Filter('Original');
Filter pop = Filter('Pop');
Filter grayscale = Filter('Grayscale');
Filter warm = Filter('Warm');
Filter cool = Filter('Cool');
Filter natural = Filter('Natural');
Filter vintage = Filter('Vintage');
Filter rise = Filter('Rise');
Filter bw = Filter('B/W');
Filter landscape = Filter('Landscape');
Filter lofi = Filter('Lo-Fi');
