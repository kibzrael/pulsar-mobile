import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final double height;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? initial;
  final Function(String text) onChanged;
  final Function(String text) onSubmitted;
  final Function()? onTap;
  final Color? color;
  final Color? clearColor;

  const SearchField({
    Key? key,
    this.autofocus = false,
    this.height = 37.5,
    this.hintText = 'Search...',
    this.color,
    this.clearColor,
    this.focusNode,
    this.controller,
    this.initial,
    required this.onChanged,
    required this.onSubmitted,
    this.onTap,
  }) : super(key: key);
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late FocusNode focusNode;
  late TextEditingController textEditingController;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    searchText = widget.initial ?? '';
    textEditingController =
        widget.controller ?? TextEditingController(text: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
        width: double.infinity,
        height: widget.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
        decoration: BoxDecoration(
            color: widget.color ??
                Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: textEditingController,
                autofocus: widget.autofocus,
                onTap: widget.onTap,
                onChanged: (text) {
                  setState(() {
                    searchText = text;
                  });
                  widget.onChanged(text);
                },
                onSubmitted: widget.onSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: widget.hintText),
              ),
            ),
            searchText.isNotEmpty
                ? TextFieldClear(
                    color: widget.clearColor,
                    onPressed: () {
                      setState(() {
                        textEditingController.clear();
                        searchText = '';
                      });
                    })
                : Container()
          ],
        ),
      ),
    );
  }
}

class TextFieldClear extends StatelessWidget {
  final Function() onPressed;
  final Color? color;
  const TextFieldClear({Key? key, required this.onPressed, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Theme.of(context).dividerColor,
        ),
        child: Icon(
          MyIcons.close,
          size: 15,
        ),
      ),
    );
  }
}
