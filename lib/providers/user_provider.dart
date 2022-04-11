import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/user.dart';
import 'package:image/image.dart' as img;
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class UserProvider extends ChangeNotifier {
  late User user;

  List<Interest>? categories;

  Future<List<Interest>> activeCategories(BuildContext context) async =>
      categories ?? await localCategories(context);

  String? get token => user.token;

  UserProvider(Map<String, dynamic>? loggedUser) {
    if (loggedUser != null) setUser(loggedUser);
    fetchCategories();
  }

  void setUser(Map<String, dynamic> newUser) {
    Map<String, dynamic> userJson = {};

    newUser.forEach((key, value) {
      if (!['thumbnail', 'medium', 'high', 'token', 'is_superuser']
          .contains(key)) {
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

    userJson.putIfAbsent('is_superuser',
        () => newUser['is_superuser'] == 1 || newUser['is_superuser']);

    user = User.fromJson(userJson);
    notifyListeners();
    // String userString = jsonEncode(newUser);
    // prefs.setString('user', userString);
  }

  Future<MyResponse> editProfile(BuildContext context,
      {String? category,
      required String bio,
      required String fullname,
      required String portfolio,
      String? birthday,
      File? profilePic,
      List<Interest> interests = const []}) async {
    File? resizedProfilePic;
    if (profilePic != null) {
      img.Image? image = img.decodeImage(profilePic.readAsBytesSync());
      if (image != null) {
        img.Image resized = img.copyResize(image, width: 480);
        String identifier = '${DateTime.now()}'.replaceAll('.', '');
        Directory dir = await getTemporaryDirectory();
        resizedProfilePic = await File(join(dir.path, '$identifier.jpg'))
            .writeAsBytes(img.encodeJpg(resized));
      }
    }
    String profileUrl = getUrl(UserUrls.profile(user.id));
    Dio dio = Dio();
    debugPrint(resizedProfilePic?.path);

    FormData form = FormData.fromMap({
      'category': category,
      'fullname': fullname,
      'bio': bio,
      'portfolio': portfolio,
      'DOB': birthday,
      'interests': interests.map((e) => e.name).join(','),
      'profilePic': resizedProfilePic == null
          ? null
          : await MultipartFile.fromFile(resizedProfilePic.path,
              filename: 'profile.jpg',
              contentType: parser.MediaType('image', 'jpeg')),
    });

    MyResponse response = MyResponse();
    try {
      Response requestResponse = await dio.post(
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

      if (requestResponse.statusCode == 200 && requestResponse.data is Map) {
        if (resizedProfilePic != null) {
          CachedNetworkImage.evictFromCache(user.profilePic?.thumbnail ?? '');
          CachedNetworkImage.evictFromCache(user.profilePic?.medium ?? '');
          CachedNetworkImage.evictFromCache(user.profilePic?.high ?? '');
        }
        Map<String, dynamic> userJson = user.toJson();
        requestResponse.data['user'].forEach((key, value) {
          if (userJson.containsKey(key)) {
            userJson.update(key, (_) => value);
          }
        });
        user = User.fromJson(userJson);
        notifyListeners();
        await Provider.of<LoginProvider>(context, listen: false)
            .saveLogin(context, token: token!, user: user.toJson());
      }

      response.statusCode = requestResponse.statusCode;
      if (requestResponse.data is Map) {
        response.body = requestResponse.data;
      } else {
        response.body = {
          'message':
              'There has been a problem processing your request. Please try again later.'
        };
      }
    } catch (e) {
      response.statusCode = 503;
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
      debugPrint(e.toString());
    }
    return response;
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

  Future fetchCategories() async {
    // await getCategories();
    // TODO: Fix cast error
    Box box = Hive.box('categories');
    if (box.isOpen) {
      if (box.isNotEmpty) {
        var boxContent = box.toMap();
        List<Map<String, dynamic>> mapContent = [];
        boxContent.forEach((key, value) {
          Map<String, dynamic> category = {};
          value.forEach((key, categoryValue) {
            late dynamic inputValue;
            if (key == 'parent' && categoryValue != null) {
              Map<String, dynamic> parent = {};
              categoryValue
                  .forEach((key, val) => parent.putIfAbsent(key, () => val));
              inputValue = parent;
            } else {
              inputValue = categoryValue;
            }
            category.putIfAbsent(key, () => inputValue);
          });
          mapContent.add(category);
        });
        // debugPrint(mapContent.toString());
        categories = [...mapContent.map((e) => Interest.fromJson(e))];
        notifyListeners();
      }
    }

    //
    try {
      String url = getUrl(UserUrls.categories);
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Authorization": token ?? ''});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var categoriesJson =
            List<Map<String, dynamic>>.from(body['categories']);
        categories = [];
        for (Map<String, dynamic> category in categoriesJson) {
          category.putIfAbsent(
              'cover',
              () => Photo(
                    thumbnail: 'assets/categories/${category["name"]}-48.png',
                    medium: 'assets/categories/${category["name"]}-96.png',
                    high: 'assets/categories/${category["name"]}-256.png',
                  ).toJson());
          Interest interest = Interest.fromJson(category);
          categories!.add(interest);
          for (Map<String, dynamic> subCategory in category['subCategories']) {
            subCategory.putIfAbsent('cover', () => interest.cover?.toJson());
            Interest subInterest = Interest.fromJson(subCategory);
            subInterest.parent = interest;
            categories!.add(subInterest);
          }
        }
        saveCategories([...categories!.map((e) => e.toJson())]);
        notifyListeners();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  getCategories() async {
    Box box = Hive.box('categories');
    if (box.isOpen) {
      if (box.isNotEmpty) {
        var boxContent = box.toMap();
        List<Map<String, dynamic>> mapContent = [];
        boxContent.forEach((key, value) {
          Map<String, dynamic> category = {};
          value.forEach((key, categoryValue) {
            late dynamic inputValue;
            if (key == 'parent' && categoryValue != null) {
              Map<String, dynamic> parent = {};
              categoryValue
                  .forEach((key, val) => parent.putIfAbsent(key, () => val));
              inputValue = parent;
            } else {
              inputValue = categoryValue;
            }
            category.putIfAbsent(key, () => inputValue);
          });
          mapContent.add(category);
        });
        // debugPrint(mapContent.toString());
        categories = [...mapContent.map((e) => Interest.fromJson(e))];
        notifyListeners();
      }
    }
  }

  saveCategories(List<Map<String, dynamic>> categories) async {
    Box box = Hive.box('categories');
    for (Map<String, dynamic> category in categories) {
      box.add(category);
    }
  }

  Future<List<Interest>> localCategories(BuildContext context) async {
    List<Interest> interests = [];
    String categoriesJson = await DefaultAssetBundle.of(context)
        .loadString('assets/categories.json');
    var categories = jsonDecode(categoriesJson);
    categories.forEach((key, item) {
      String cover = item['cover'];
      Interest interest = Interest(
        name: key,
        user: item['user'],
        users: item['users'],
        cover: Photo(
          thumbnail: 'assets/categories/$cover-48.png',
          medium: 'assets/categories/$cover-96.png',
          high: 'assets/categories/$cover-256.png',
        ),
      );
      interests.add(interest);
      Map<String, dynamic>? subcategories = item['subcategories'];
      if (subcategories != null) {
        subcategories.forEach((key, item) {
          String? cover = item['cover'];
          interests.add(
            Interest(
                name: key,
                user: item['user'] ?? interest.user,
                users: item['users'] ?? interest.users,
                cover: cover != null
                    ? Photo(
                        thumbnail: 'assets/categories/$cover-48.png',
                        medium: 'assets/categories/$cover-96.png',
                        high: 'assets/categories/$cover-256.png',
                      )
                    : interest.cover,
                parent: interest),
          );
        });
      }
    });
    return interests;
  }

  notify() {
    notifyListeners();
  }
}
