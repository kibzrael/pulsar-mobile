import 'package:flutter/material.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/report.dart';

class User {
  int id;
  String username;
  String category;
  String? fullname;
  String? profilePic;
  String? bio;
  String? portfolio;
  List<Interest> interests;
  String? email;
  String? phone;
  DateTime? dateOfBirth;
  bool isSuperuser;

  String? token;

  int? followers;
  int? posts;

  bool? isFollowing;
  bool? isBlocked;
  bool? postNotifications;

  /// Create a user from info.
  ///
  /// id and username are required
  User(this.id,
      {required this.username,
      required this.category,
      this.bio,
      this.dateOfBirth,
      this.email,
      this.fullname,
      this.interests = const [],
      this.isBlocked,
      this.isFollowing,
      this.phone,
      this.followers,
      this.portfolio,
      this.posts,
      this.profilePic,
      this.isSuperuser = false});

  // Create a user from a json/ map
  //
  // map should contain id and username fields

  User.fromJson(Map<String, dynamic> info)
      : assert(info['id'] != null),
        assert(info['username'] != null),
        assert(info['username'] is String),
        id = info['id'] is int ? info['id'] : int.tryParse(info['id']),
        username = info['username'],
        bio = info['bio'],
        category = info['category'] ?? "Personal Account",
        dateOfBirth = DateTime.tryParse(info['dateOfBirth'] ?? ''),
        email = info['email'],
        fullname = info['fullname'],
        isBlocked = info['isBlocked'],
        isFollowing = info['isFollowing'],
        interests = info['interests'] ?? [],
        phone = info['phone'],
        followers = info['followers'],
        portfolio = info['portfolio'],
        posts = info['posts'],
        profilePic = info['profilePic'],
        isSuperuser = info['superuser'] ?? false;

  toJson(BuildContext context) {
    return {
      'id': this.id,
      'username': this.username,
      'bio': this.bio,
      'category': this.category,
      'email': this.email,
      'fullname': this.fullname,
      'phone': this.phone,
      'profilePic': this.profilePic,
      'portfolio': this.portfolio,
      'token': token
    };
  }

  follow(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  block(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  report(BuildContext context, Report report) {}

  subcribeForPostNotifications(BuildContext context,
      {RequestMethod mode = RequestMethod.post}) {}

  getPosts() {}

  getReposts() {}

  getInterests(BuildContext context) {}

  getFollowers() {}

  // message(Message message) {}

  String? get getProfileUrl {
    // User user = this;
    // String url = UserUrls.profile(user);
  }

  bool get profileIsComplete {
    List info = [
      id,
      username,
      fullname,
      category,
      profilePic,
      bio,
      posts,
      followers,
      isFollowing
    ];
    return !info.any((element) => element == null);
  }

  getProfile() {}

  /// Use to edit the class
  User update(BuildContext context, User newUser) {
    // ensure userprovider.id == id

    // username = newUser.username ?? username;
    // bio = newUser.bio ?? bio;
    // category = newUser.category ?? category;
    // dateOfBirth = newUser.dateOfBirth ?? dateOfBirth;
    // email = newUser.email ?? email;
    // fullname = newUser.fullname ?? fullname;
    // interests = newUser.interests ?? interests;
    // phone = newUser.phone ?? phone;
    // portfolio = newUser.portfolio ?? portfolio;
    // profilePic = newUser.profilePic ?? profilePic;
    return this;
  }

  /// Use to edit profile in the server.
  /// Use update to change details.
  ///
  /// Note: editProfile uses the current class values.
  Future<User> editProfile(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    return this;
  }

  delete(BuildContext context) {}
}

enum RequestMethod { post, delete }
