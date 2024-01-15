import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_auth/data/user_repository/entities/my_user_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class PostEntity {
  String postId;
  DateTime createAt;
  MyUser myUser;
  String? content;
  String? imageUrl;
  int commentsCount;
  int likesCount;

  PostEntity({
    required this.postId,
    required this.createAt,
    required this.myUser,
    this.content,
    this.imageUrl,
    this.commentsCount = 0,
    this.likesCount = 0,
  });

  Map<String, Object?> toDocument() {
    return {
      'postId': postId,
      'content': content,
      'createAt': createAt,
      'myUser': myUser.toEntity().toDocument(),
      'imageUrl': imageUrl,
      'commentsCount': commentsCount,
      'likesCount': likesCount,
    };
  }

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc['postId'] as String,
      content: doc['content'] as String,
      imageUrl: doc['imageUrl'] as String,
      createAt: (doc['createAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
      likesCount: doc['likesCount'] as int,
      commentsCount: doc['commentsCount'] as int,
    );
  }

  List<Object?> get props =>
      [postId, content, imageUrl, createAt, myUser, likesCount, commentsCount];
}
