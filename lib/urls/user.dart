class UserUrls {
  UserUrls._();

  static String profile(int id) => 'users/$id';

  /// url to get followers, follow and unfollow
  static String follow(int id) => 'users/$id/followers';

  static String block(int id) => 'users/$id/blocks';

  static String posts(int id) => 'users/$id/posts';

  static String changeUsername = 'change_username';

  static String changePassword = 'change_password';
}
