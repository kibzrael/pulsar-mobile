import 'package:flutter/material.dart';
import 'package:pulsar/functions/upload_post.dart';

class BackgroundOperations extends ChangeNotifier {
  UploadPost? uploadPost;

  bool get isUploadingPost => uploadPost != null;

  notify() {
    notifyListeners();
  }
}
