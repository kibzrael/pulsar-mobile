import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/text_button.dart';

class Filters extends StatefulWidget {
  final PostProvider postProvider;
  const Filters(this.postProvider, {Key? key}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<Filter> filters = [
    original,
    pop,
    sepia,
    grayscale,
    warm,
    cool,
    natural,
    vintage,
    rise,
    bw,
    landscape,
    lofi,
    invert,
  ];

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.headline1),
            MyTextButton(text: 'Done', onPressed: () => Navigator.pop(context))
          ],
        ),
      ),
      child: Container(
        height: 125,
        margin: const EdgeInsets.only(bottom: 18, top: 4),
        child: ListView.builder(
            itemCount: filters.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (context, index) {
              bool isSelected = widget.postProvider.filter == filters[index];
              return InkWell(
                  onTap: () {
                    setState(() {
                      widget.postProvider.filter = filters[index];
                      widget.postProvider.notify();
                    });
                  },
                  child: FilterWidget(
                    filters[index],
                    selected: isSelected,
                  ));
            }),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final Filter filter;
  final bool selected;
  const FilterWidget(this.filter, {Key? key, required this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
      padding: const EdgeInsets.all(4),
      width: 100,
      decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).inputDecorationTheme.fillColor
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.matrix(filter.convolution),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white12,
              backgroundImage: CachedNetworkImageProvider(beth.profilePic!),
            ),
          ),
          const SizedBox(height: 4),
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

Filter original = Filter('Original',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter pop = Filter('Pop',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter sepia = Filter('Sepia', convolution: [
  0.393,
  0.769,
  0.189,
  0,
  0,
  0.349,
  0.686,
  0.168,
  0,
  0,
  0.272,
  0.534,
  0.131,
  0,
  0,
  0,
  0,
  0,
  1,
  0
]);
Filter grayscale = Filter('Grayscale', convolution: [
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0
]);
Filter warm = Filter('Warm',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter cool = Filter('Cool',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter natural = Filter('Natural',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter vintage = Filter('Vintage',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter rise = Filter('Rise',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter bw = Filter('B/W',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter landscape = Filter('Landscape',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter lofi = Filter('Lo-Fi',
    convolution: [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
Filter invert = Filter('Invert', convolution: [
  -1,
  0,
  0,
  0,
  255,
  0,
  -1,
  0,
  0,
  255,
  0,
  0,
  -1,
  0,
  255,
  0,
  0,
  0,
  1,
  0
]);
