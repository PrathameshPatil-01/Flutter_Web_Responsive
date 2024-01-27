import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:web_auth/data/comment_repository/entities/comment_entity.dart';
import 'package:web_auth/data/comment_repository/models/comment.dart';
import 'package:web_auth/data/post_repository/entities/post_entity.dart';
import 'package:web_auth/data/post_repository/models/post.dart';

import 'comment_repo.dart';

class FirebaseCommentRepository implements CommentRepository {
  @override
  Future<Post> createComment(String postId, Comment comment) async {
    try {
      final postDoc =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      comment.commentId = const Uuid().v1();
      comment.createdAt = DateTime.now();

      // Use arrayUnion to add a new comment to the "comments" array field
      await postDoc.update({
        'comments': FieldValue.arrayUnion([
          {
            'commentId': comment.commentId,
            'commentText': comment.commentText,
            'myUser': comment.myUser.toEntity().toDocument(),
            'createdAt': comment.createdAt,
          },
        ]),
      });

      final postSnapshot = await postDoc.get();

      final updatedPost =
          Post.fromEntity(PostEntity.fromDocument(postSnapshot.data()!));

      return updatedPost;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Comment>> getComment(String postId) async {
    try {
      final postDoc =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      final docSnapshot = await postDoc.get();
      if (!docSnapshot.exists) {
        return [];
      }

      final postData = docSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> commentsData = postData['comments'] ?? [];

      return commentsData
          .map((commentData) =>
              Comment.fromEntity(CommentEntity.fromDocument(commentData)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Other methods...

  @override
  Future<int> getCommentCountForPost(String postId) async {
    try {
      final postDoc =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      final docSnapshot = await postDoc.get();
      if (!docSnapshot.exists) {
        return 0;
      }

      final postData = docSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> commentsData = postData['comments'] ?? [];

      return commentsData.length;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
