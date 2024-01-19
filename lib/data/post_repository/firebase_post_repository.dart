import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';
import 'package:web_auth/data/post_repository/entities/post_entity.dart';
import 'package:web_auth/data/post_repository/models/post.dart';

import 'post_repo.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<Post> createPost(Post post) async {
    try {
      post.postId = const Uuid().v1();
      post.createAt = DateTime.now();

      await postCollection.doc(post.postId).set(post.toEntity().toDocument());

      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Post>> getPost() async {
    try {
      final querySnapshot =
          await postCollection.orderBy('createAt', descending: true).get();

      return querySnapshot.docs
          .map((doc) => Post.fromEntity(PostEntity.fromDocument(doc.data())))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadPostImage(
      html.File file, String postId, String userId) async {
    try {
      html.File imageFile = file;
      Reference firebaseStoreRef = FirebaseStorage.instance
          .ref()
          .child('$userId/Post_Images/$postId.jpg');
      await firebaseStoreRef.putBlob(
        imageFile,
      );
      String url = await firebaseStoreRef.getDownloadURL();
      await postCollection.doc(postId).update({'imageUrl': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Post> likePost(String postId, String userId) async {
    try {
      var postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        var postEntity = PostEntity.fromDocument(postDoc.data()!);

        if (postEntity.likes.contains(userId)) {
          postEntity.likes.remove(userId);
        } else {
          postEntity.likes.add(userId);
        }

        await postCollection.doc(postId).update(postEntity.toDocument());

        return Post.fromEntity(postEntity);
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> getPostCountForUser(String userId) async {
    try {
      QuerySnapshot userPostsSnapshot =
          await postCollection.where('myUser.id', isEqualTo: userId).get();

      return userPostsSnapshot.size;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
