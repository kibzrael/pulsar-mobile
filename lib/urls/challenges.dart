class ChallengesUrl {
  ChallengesUrl._();

  static String myGalaxy = 'pages/galaxy';

  static String pinned(int index) => 'challenges/pinned?offset=$index';

  static String top = 'challenges/chart';

  static String highlight = 'challenges/highlight';

  static String discover(String tag, int index) =>
      'challenges/discover?tag=$tag&offset=$index';

  static String search(String keyword, int index) =>
      'challenges/search?keyword=$keyword&offset=$index';
}
