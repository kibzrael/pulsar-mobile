import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/user.dart';
import 'package:image/image.dart' as img;
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class UserProvider extends ChangeNotifier {
  late User user;

  String? get token => user.token;

  UserProvider(Map<String, dynamic>? loggedUser) {
    if (loggedUser != null) setUser(loggedUser);
  }

  void setUser(Map<String, dynamic> newUser) {
    Map<String, dynamic> userJson = {};
    debugPrint(newUser.toString());

    newUser.forEach((key, value) {
      if (!['thumbnail', 'medium', 'high', 'token'].contains(key)) {
        userJson.putIfAbsent(key, () => value);
      }
    });

    userJson.putIfAbsent('jwtToken', () => newUser['token']);

    if (newUser['thumbnail'] != null) {
      userJson.putIfAbsent(
          'profile_pic',
          () => {
                'thumbnail': newUser['thumbnail'],
                'medium': newUser['medium'],
                'high': newUser['high'],
              });
    }
    user = User.fromJson(userJson);
    debugPrint(userJson.toString());
    debugPrint(token);
    notifyListeners();
    // String userString = jsonEncode(newUser);
    // prefs.setString('user', userString);
  }

  editProfile(BuildContext context,
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
    String profileUrl = getUrl(UserUrls.profile(user.id));
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
        'Authorization': token ?? '',
        "Content-type": "multipart/form-data",
      }),
      data: form,
      onSendProgress: (int sent, int total) {
        debugPrint("sent${sent.toString()} total${total.toString()}");
      },
    );

    if (response.statusCode == 200 && response.data is Map) {
      Map<String, dynamic> userJson = user.toJson();
      response.data['user'].forEach((key, value) {
        if (userJson.containsKey(key)) {
          userJson.update(key, (_) => value);
        }
      });
      user = User.fromJson(userJson);

      await Provider.of<LoginProvider>(context, listen: false)
          .saveLogin(context, token: token!, user: user.toJson());
      notifyListeners();
    }

    if (kDebugMode) {
      print(response.statusCode);
      print(response.data);
      debugPrint(profileUrl);
      debugPrint(resizedProfilePic?.path);
    }

    return;
  }

  Future<MyResponse> changeUsername(
      BuildContext context, String username) async {
    String url = getUrl(UserUrls.changeUsername);
    http.Response requestResponse = await http.post(Uri.parse(url), headers: {
      'Authorization': token ?? '',
    }, body: {
      'username': username
    });
    MyResponse response = MyResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }

    if (response.statusCode == 200) {
      user.username = username;
      await Provider.of<LoginProvider>(context, listen: false)
          .saveLogin(context, token: token!, user: user.toJson());
      notifyListeners();
    }
    return response;
  }
}
