import 'package:flutter/material.dart';

class MyTextInput extends StatefulWidget {
  final String hintText;
  final double? height;
  final bool obscureText;
  final Function(String text) onChanged;
  final Function(String text) onSubmitted;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final int maxLines;
  final EdgeInsetsGeometry padding;

  final Widget? prefix;
  final Widget? suffix;

  const MyTextInput(
      {Key? key,
      this.controller,
      this.focusNode,
      this.height = 50,
      this.hintText = '',
      this.maxLines = 1,
      this.obscureText = false,
      required this.onChanged,
      required this.onSubmitted,
      this.padding = const EdgeInsets.symmetric(horizontal: 12),
      this.prefix,
      this.suffix})
      : super(key: key);
  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
        width: double.infinity,
        height: widget.height,
        alignment: Alignment.center,
        padding: widget.padding,
        decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            widget.prefix ?? Container(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  minLines: 1,
                  maxLines: widget.maxLines,
                  decoration:
                      InputDecoration.collapsed(hintText: widget.hintText),
                ),
              ),
            ),
            widget.suffix ?? Container(),
          ],
        ),
      ),
    );
  }
}
