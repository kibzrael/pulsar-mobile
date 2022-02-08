String roundCount(int count) {
  String response;
  if (count < 1000) {
    response = '$count';
  } else if (count < 1000000) {
    double divide = count / 1000;
    String round = divide.toStringAsFixed(2);
    response = "${removeTrailingZero(round)}K";
  } else if (count < 1000000000) {
    double divide = count / 1000000;
    String round = divide.toStringAsFixed(2);
    response = "${removeTrailingZero(round)}M";
  } else {
    double divide = count / 1000000000;
    String round = divide.toStringAsFixed(2);
    response = "${removeTrailingZero(round)}B";
  }

  return response;
}

String removeTrailingZero(String string) {
  if (!string.contains('.')) {
    return string;
  }
  string = string.replaceAll(RegExp(r'0*$'), '');
  if (string.endsWith('.')) {
    string = string.substring(0, string.length - 1);
  }
  return string;
}
