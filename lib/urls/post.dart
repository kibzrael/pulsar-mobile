import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/post.dart';

class PostUrls {
  PostUrls._();

  static String upload = 'posts/';

  // get post, edit, and delete
  static String postItem(Post post) => 'posts/${post.id}';

  static String like(Post post) => 'posts/${post.id}/likes';

  static String comments(int post, {int? index, int? replyTo}) =>
      'posts/$post/comments${index == null ? '' : '?offset=$index'}${replyTo == null ? '' : (index == null ? '?' : '&') + 'replyTo=$replyTo'}';

  static String comment(Comment comment) =>
      'posts/${comment.post}/comments/${comment.id}';

  static String commentLike(Comment comment) =>
      'posts/${comment.post}/comments/${comment.id}/likes';

  static String repost(Post post) => 'posts/${post.id}/reposts';
}
