class HomeUrls {
  HomeUrls._();

  static String feed(int index) => 'pages/home';

  static String discover(String tag, int index) =>
      'pages/discover_posts?tag=$tag&offset=$index';

  static String discoverUsers(int index) => 'pages/discover_users?offset=$index';
}
