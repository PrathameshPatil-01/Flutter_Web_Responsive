import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_auth/data/user_repository/entities/my_user_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class PostEntity {
  String postId;
  DateTime createdAt;
  MyUser myUser;
  String? content;
  String? imageUrl;
  List<String> likes; // List to store user IDs who liked the post
  List<dynamic> comments; // List to store user IDs who commented on the post

  PostEntity({
    required this.postId,
    required this.createdAt,
    required this.myUser,
    this.content,
    this.imageUrl,
    this.likes = const [], // Initialize with an empty list
    this.comments = const [], // Initialize with an empty list
  });

  Map<String, Object?> toDocument() {
    return {
      'postId': postId,
      'content': content,
      'createdAt': createdAt,
      'myUser': myUser.toEntity().toDocument(),
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
    };
  }

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc['postId'] as String,
      content: doc['content'] as String,
      imageUrl: doc['imageUrl'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
      likes: List<String>.from(doc['likes'] ?? []),
      comments: List<dynamic>.from(doc['comments'] ?? []),
    );
  }

  List<Object?> get props =>
      [postId, content, imageUrl, createdAt, myUser, likes, comments];
}
