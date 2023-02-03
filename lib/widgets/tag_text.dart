import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

class TagTextBuilder extends SpecialTextSpanBuilder {
  BuildContext context;
  TextEditingController controller;

  TagTextBuilder(this.context, {required this.controller});

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    return TagText(textStyle, (parameter) {},
        start: index,
        controller: controller,
        context: context,
        startFlag: flag);
  }
}

class TagText extends SpecialText {
  final TextEditingController controller;
  final int start;
  final BuildContext context;
  TagText(TextStyle? textStyle, SpecialTextGestureTapCallback onTap,
      {required this.start,
      required this.controller,
      required this.context,
      required String startFlag})
      : super(startFlag, " ", textStyle, onTap: onTap);

  @override
  InlineSpan finishText() {
    final String text = toString();

    return ExtendedWidgetSpan(
        actualText: text,
        start: start,
        alignment: PlaceholderAlignment.middle,
        deleteAll: false,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 2.0, bottom: 2.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  color: Colors.orange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        text.trim(),
                        //style: textStyle?.copyWith(color: Colors.orange),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.close,
                          size: 15.0,
                        ),
                        onTap: () {
                          controller.value = controller.value.copyWith(
                              text: controller.text
                                  .replaceRange(start, start + text.length, ""),
                              selection: TextSelection.fromPosition(
                                  TextPosition(offset: start)));
                        },
                      )
                    ],
                  ),
                )),
          ),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (c) {
                  TextEditingController textEditingController =
                      TextEditingController()..text = text.trim();
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Material(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              suffixIcon: TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              controller.value = controller.value.copyWith(
                                  text: controller.text.replaceRange(
                                      start,
                                      start + text.length,
                                      "${textEditingController.text} "),
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          offset: start +
                                              ("${textEditingController.text} ")
                                                  .length)));

                              Navigator.pop(context);
                            },
                          )),
                        ),
                      )),
                      Expanded(
                        child: Container(),
                      )
                    ],
                  );
                });
          },
        ));
  }
}
