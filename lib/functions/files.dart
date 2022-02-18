String fileSize(int bytes) {
  String extension = 'B';
  double value = bytes.toDouble();

  if (value > 1000000000) {
    extension = 'GB';
    value = value / 1000000000;
  } else if (value > 1000000) {
    extension = 'MB';
    value = value / 1000000;
  } else if (value > 1000) {
    extension = 'KB';
    value = value / 1000;
  }

  return '${value.toStringAsFixed(1)} $extension';
}
