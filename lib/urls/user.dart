class UserUrls {
  UserUrls._();

  static String profile(int id) => 'users/$id';

  /// url to get followers, follow and unfollow
  static String follow(int id, {int? index}) =>
      'users/$id/followers${index == null ? '' : '?offset=$index'}';

  static String block(int id, {int? index}) =>
      'users/$id/blocks${index == null ? '' : '?offset=$index'}';

  static String posts(int id, int index, int offset) =>
      'users/$id/posts?index=$index&offset=$offset';

  static String notifications(int id, {int? index}) =>
      'users/$id/notifications${index == null ? '' : '?offset=$index'}';

  static String changeUsername = 'change_username';

  static String changePassword = 'change_password';

  static String categories = 'categories';

  static String createCategory = 'create_category';

  static String search(String keyword, int index) =>
      'users/search?keyword=$keyword&offset=$index';
}
