class UserUrls {
  UserUrls._();

  static String profile(int id) => 'users/$id';

  /// url to get followers, follow and unfollow
  static String follow(int id) => 'users/$id/followers';

  static String block(int id) => 'users/$id/blocks';

  static String posts(int id, int index) => 'users/$id/posts?index=$index';

  static String changeUsername = 'change_username';

  static String changePassword = 'change_password';

  static String categories = 'categories';

  static String createCategory = 'create_category';
}
