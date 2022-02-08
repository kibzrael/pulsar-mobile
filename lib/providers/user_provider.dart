import 'dart:io';

import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulsar/classes/user.dart';
import 'package:image/image.dart' as img;
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class UserProvider extends ChangeNotifier {
  User? user;

  String? get token => user?.token;

  UserProvider(Map<String, dynamic>? loggedUser) {
    if (loggedUser != null) setUser(loggedUser);
  }

  void setUser(Map<String, dynamic> newUser) {
    user = User.fromJson(newUser);
    notifyListeners();
    // String userString = jsonEncode(newUser);
    // prefs.setString('user', userString);
  }

  editProfile(
      {required String bio,
      required String fullname,
      required String portfolio,
      File? profilePic}) async {
    File? resizedProfilePic;
    if (profilePic != null) {
      // split into three different qualities
      img.Image? image = img.decodeImage(profilePic.readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);

        Directory dir = await getApplicationDocumentsDirectory();
        resizedProfilePic =
            await File(join(dir.path, '${DateTime.now()}', '.jpg'))
                .writeAsBytes(img.encodeJpg(resized));
      }
    }
    String profileUrl = getUrl(UserUrls.profile(user!.id));
    Dio dio = Dio();

    Response response = await dio.post(profileUrl,
        options: Options(headers: {'Authorization': token!}),
        data: {
          'fullname': fullname,
          'bio': bio,
          'portfolio': portfolio,
          'profilePic': resizedProfilePic == null
              ? null
              : MultipartFile.fromBytes(await resizedProfilePic.readAsBytes(),
                  contentType: parser.MediaType('images', 'jpeg')),
        });

    print(response.statusCode);
    print(response.data);
    return;
  }
}
