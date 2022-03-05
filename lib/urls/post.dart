import 'package:pulsar/classes/post.dart';

class PostUrls {
  PostUrls._();

  static String upload = 'posts';

  // get post, edit, and delete
  static String postItem(Post post) => 'posts/${post.id}';

  static String like(Post post) => 'posts/${post.id}/likes';

  static String comment(Post post) => 'posts/${post.id}/comments';

  static String repost(Post post) => 'posts/${post.id}/reposts';
}
