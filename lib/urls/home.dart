class HomeUrls {
  HomeUrls._();

  static String feed(int index) => '';

  static String discover(String tag, int index) =>
      'discover_posts?tag=$tag&offset=$index';

  static String discoverUsers(int index) => 'discover_users?offset=$index';
}
