import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';
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
      {String? category,
      required String bio,
      required String fullname,
      required String portfolio,
      String? birthday,
      File? profilePic}) async {
    File? resizedProfilePic;
    if (profilePic != null) {
      img.Image? image = img.decodeImage(profilePic.readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);
        String identifier = '${DateTime.now()}'.replaceAll('.', '');
        Directory dir = await getApplicationDocumentsDirectory();
        resizedProfilePic = await File(join(dir.path, '$identifier.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }
    String profileUrl = getUrl(UserUrls.profile(user!.id));
    Dio dio = Dio();

    FormData form = FormData.fromMap({
      'category': category,
      'fullname': fullname,
      'bio': bio,
      'portfolio': portfolio,
      'DOB': birthday,
      'profilePic': resizedProfilePic == null
          ? null
          : {
              'image': await MultipartFile.fromFile(resizedProfilePic.path,
                  filename: 'profile.jpg',
                  contentType: parser.MediaType('image', 'jpeg')),
              "type": "image/jpg"
            }
    });

    Response response = await dio.post(
      profileUrl,
      options: Options(headers: {
        'Authorization': token!,
        "Content-type": "multipart/form-data",
      }),
      data: form,
      onSendProgress: (int sent, int total) {
        debugPrint("sent${sent.toString()} total${total.toString()}");
      },
    );

    if (kDebugMode) {
      print(response.statusCode);
      Fluttertoast.showToast(msg: response.data);
      print(response.data);
      debugPrint(profileUrl);
      debugPrint(resizedProfilePic?.path);
    }

    return;
  }
}
