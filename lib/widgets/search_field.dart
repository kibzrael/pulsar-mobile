import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final double height;
  final bool autofocus;
  final Function(String text) onChanged;
  final Function(String text) onSubmitted;
  final Color? color;
  final Color? clearColor;

  SearchField({
    this.autofocus = false,
    this.height = 37.5,
    this.hintText = 'Search...',
    this.color,
    this.clearColor,
    required this.onChanged,
    required this.onSubmitted,
  });
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode? focusNode;
  TextEditingController? textEditingController;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        focusNode!.requestFocus();
      },
      child: Container(
        width: double.infinity,
        height: widget.height,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(12, 4, 8, 4),
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
            searchText.length > 0
                ? TextFieldClear(
                    color: widget.clearColor,
                    onPressed: () {
                      setState(() {
                        textEditingController!.clear();
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
  TextFieldClear({required this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4),
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
