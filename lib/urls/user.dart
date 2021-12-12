import 'package:pulsar/classes/user.dart';

class UserUrls {
  UserUrls._();

  static String profile(User user) => '/users/${user.id}';

  /// url to get followers, follow and unfollow
  static String follow(User user) => '/users/${user.id}/followers';

  static String posts(User user) => '/users/${user.id}/posts';
}
