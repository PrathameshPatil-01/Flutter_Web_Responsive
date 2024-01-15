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
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/Post_Images/$postId.jpg');
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
}
