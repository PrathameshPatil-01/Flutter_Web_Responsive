import 'package:universal_html/html.dart' as html;
import 'package:web_auth/data/post_repository/models/post.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post);

  Future<List<Post>> getPost();

  Future<String> uploadPostImage(html.File file, String postId, String userId);

  Future<Post> likePost(String postId, String userId);

  Future<int> getPostCountForUser(String userId);
}
