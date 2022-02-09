import 'package:flutter/material.dart';

List<InlineSpan> captionText(String caption) {
  List<InlineSpan> span = [];

  List<String> splits = caption.split(' ');

  for (String split in splits) {
    if (split.startsWith('#')) {
      String allowedCharacters = "abcdefghijklmnopqrstuvwxyz1234567890_";

      String hashtag = '';
      bool spoilt = false;

      for (int i = 0; i < split.length; i++) {
        String letter = split[i];
        if (allowedCharacters.contains(letter.toLowerCase()) &&
            hashtag.length < 15 &&
            !spoilt) {
          hashtag += letter.toLowerCase();
        } else {
          if (letter != '#') {
            spoilt = true;
          } else if (letter == '#' && hashtag != '') {
            span.add(TextSpan(
                text: '#$hashtag${spoilt ? '' : ' '}',
                style: const TextStyle(color: Colors.blue)));
            hashtag = '';
          }
        }
      }
      span.add(TextSpan(
          text: '#$hashtag${spoilt ? '' : ' '}',
          style: const TextStyle(color: Colors.blue)));
      if (spoilt) {
        String suffix = '';
        String splitCopy = split.replaceAll('#$hashtag', '');
        bool spoiltIndex = false;
        for (int i = 0; i < splitCopy.length; i++) {
          String letter = splitCopy[i];
          if (spoiltIndex) {
            suffix += letter;
          } else if (!allowedCharacters.contains(letter.toLowerCase())) {
            suffix += letter;
            spoiltIndex = true;
          }
        }

        if (suffix != '') {
          span.add(TextSpan(text: '$suffix '));
        }
      }
    } else if (split.startsWith(('@'))) {
    } else {
      span.add(TextSpan(text: '$split '));
    }
  }

  return span;
}
