import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/post.dart';

class PostUrls {
  PostUrls._();

  static String upload = 'posts';

  // get post, edit, and delete
  static String postItem(Post post) => 'posts/${post.id}';

  static String like(Post post) => 'posts/${post.id}/likes';

  static String comment(int post, {int? index, int? replyTo}) =>
      'posts/$post/comments${index == null ? '' : '?offset=$index'}${replyTo == null ? '' : '&replyTo=$replyTo'}';

  static String commentLike(Comment comment) => 'comments/${comment.id}/likes';

  static String repost(Post post) => 'posts/${post.id}/reposts';
}
