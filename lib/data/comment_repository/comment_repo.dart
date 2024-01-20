import 'package:web_auth/data/comment_repository/models/comment.dart';
import 'package:web_auth/data/post_repository/models/post.dart';

abstract class CommentRepository {
  Future<Post> createComment(String postId, Comment comment);

  Future<List<Comment>> getComment(String postId);

  Future<int> getCommentCountForPost(String postId);
}
