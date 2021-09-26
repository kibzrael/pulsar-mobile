import 'package:flutter/material.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';

class DiscoverGalaxyTags extends StatefulWidget {
  final String selected;
  final Function(String value) onChanged;

  DiscoverGalaxyTags({required this.selected, required this.onChanged});

  @override
  _DiscoverGalaxyTagsState createState() => _DiscoverGalaxyTagsState();
}

class _DiscoverGalaxyTagsState extends State<DiscoverGalaxyTags> {
  List<Interest> tags = allCategories;

  String get selected => widget.selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemCount: tags.length + 2,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String name = index == 0
                ? 'For you'
                : index == 1
                    ? 'Trending'
                    : tags[index - 2].name;
            return GalaxyTag(
                text: name,
                isSelected: selected == name,
                onPressed: widget.onChanged);
          }),
    );
  }
}

class GalaxyTag extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function(String interest) onPressed;

  GalaxyTag(
      {required this.text, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(text),
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.5,
                color: Theme.of(context).dividerColor,
                style: isSelected ? BorderStyle.none : BorderStyle.solid),
            gradient: isSelected
                ? LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryVariant
                  ])
                : null,
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.5,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.subtitle2!.color),
        ),
      ),
    );
  }
}
