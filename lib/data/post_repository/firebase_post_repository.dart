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
  Future<List<Post>> getPost() {
    try {
      return postCollection.get().then((value) => value.docs
          .map((e) => Post.fromEntity(PostEntity.fromDocument(e.data())))
          .toList());
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
      // Fetch the post
      var postDoc = await postCollection.doc(postId).get();
      if (postDoc.exists) {
        // Convert the document to a PostEntity
        var postEntity = PostEntity.fromDocument(postDoc.data()!);

        // Check if the user is already in the likes list
        if (postEntity.likes.contains(userId)) {
          // User is already in the likes, remove the user
          postEntity.likes.remove(userId);
        } else {
          // User is not in the likes, add the user
          postEntity.likes.add(userId);
        }

        // Update the post in Firestore
        await postCollection.doc(postId).update(postEntity.toDocument());

        // Return the updated list of likes
        return Post.fromEntity(postEntity);
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
