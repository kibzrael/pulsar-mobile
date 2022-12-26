import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/username.dart';

import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/route.dart';

class SignInfoProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  List<Interest> interests = [];

  int? _page;

  late SignUserInfo user;

  late String _signupUrl;

  String? token;

  String? deviceToken;

  SignInfoProvider(this.deviceToken) {
    _pageController = PageController();
    _signupUrl = getUrl(AuthUrls.signupUrl);
    user = SignUserInfo();
  }

  fetchInterests(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    interests = await userProvider.activeCategories(context);
  }

  Future<MyResponse> signup(
      String email, String username, String password) async {
    Uri url = Uri.parse(_signupUrl);
    http.Response requestResponse = await http.post(
      url,
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    MyResponse response = MyResponse();
    response.statusCode = requestResponse.statusCode;
    //
    var body = jsonDecode(requestResponse.body);
    if (body is Map) {
      response.body = body;
    }

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 300));

      notifyListeners();
    }
    return response;
  }

  previousPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! - 1);
  }

  nextPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! + 1);
  }

  googleSignup(BuildContext context, GoogleSignInAccount account,
      String? accessToken) async {
    fetchInterests(context);
    if (account.photoUrl != null) {
      http.get(Uri.parse(account.photoUrl!)).then((response) async {
        Directory dir = await getApplicationDocumentsDirectory();
        String photoPath = join(dir.path, 'img-${account.id}.png');
        File photo = File(photoPath);
        await photo.writeAsBytes(response.bodyBytes);
        user.profilePic = photoPath;
      });
    }
    Navigator.of(context).push(myPageRoute(
        builder: (context) => SelectUsername(
                onSubmit: (BuildContext context, String username) async {
              http.Response response = await openDialog(
                  context,
                  (_) => LoadingDialog(
                        (_) async {
                          Uri url = Uri.parse(getUrl(AuthUrls.googleSignup));
                          http.Response response = await http.post(
                            url,
                            body: {
                              'id': account.id,
                              'email': account.email,
                              'username': username,
                              'auth_code': account.serverAuthCode,
                              'access_token': accessToken,
                              'device_token': deviceToken ?? ''
                            },
                          );

                          return response;
                        },
                        text: 'Submitting',
                      ));
              if (response.statusCode == 201) {
                var data = jsonDecode(response.body);
                user.id = data['user']['id'];
                user.username = data['user']['username'];
                user.birthday = data['user']['date_of_birth'] == null
                    ? null
                    : DateTime.parse(data['user']['date_of_birth'] as String);
                token = data['user']['jwtToken'];
                LoginProvider loginProvider =
                    Provider.of<LoginProvider>(context, listen: false);
                await loginProvider.signup(context,
                    token: token ?? '', user: data['user']);
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    myPageRoute(builder: (context) => const SignInfo()));
              } else if (response.statusCode == 422) {
                var data = jsonDecode(response.body);
                openDialog(
                  context,
                  (context) => MyDialog(
                    title: statusCodes[response.statusCode]!,
                    body: data['message'],
                    actions: const ['Ok'],
                  ),
                );
              } else {
                Fluttertoast.showToast(msg: "Error Signing up");
              }
            })));
  }

  submit(BuildContext context) async {
    File? profilePic;
    if (user.profilePic != null) {
      // split into three different qualities
      img.Image? image =
          img.decodeImage(File(user.profilePic!).readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);

        Directory dir = await getTemporaryDirectory();
        profilePic = await File(join(dir.path, '${DateTime.now()} resized.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }

    String profileUrl = getUrl(UserUrls.profile(user.id!));

    Dio dio = Dio();

    String? birthday = user.birthday?.toString().split(' ')[0];

    FormData form = FormData.fromMap({
      'category': user.category.name,
      'fullname': user.username,
      'DOB': birthday,
      'type': '',
      'interests': user.interests?.map((e) => e.name).join(',') ?? '',
      'profilePic': profilePic == null
          ? null
          : await MultipartFile.fromFile(profilePic.path,
              filename: 'profile.jpg',
              contentType: parser.MediaType('image', 'jpeg'))
    });

    try {
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
        Map<String, dynamic> userJson = {};
        response.data['user'].forEach((key, value) {
          userJson.putIfAbsent(key, () => value);
        });
        userJson.putIfAbsent("jwtToken", () => token);
        User userObject = User.fromJson(userJson);
        await Provider.of<LoginProvider>(context, listen: false)
            .saveLogin(context, token: token!, user: userObject.toJson());

        debugPrint('Saved user');
        Fluttertoast.showToast(msg: 'Saved user');
      }
    } catch (e) {
      debugPrint("Sign info provider" + e.toString());
      Fluttertoast.showToast(msg: "Sign info provider" + e.toString());
    }

    return;
  }
}

class SignUserInfo {
  int? id;
  String? username;
  UserType? userType;
  DateTime? birthday;
  Interest category =
      Interest(name: 'Personal Account', user: 'Personal Account');
  String? profilePic;
  List<Interest>? interests;
}

enum UserType { solo, group }
