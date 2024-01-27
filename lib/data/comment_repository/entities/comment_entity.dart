import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_auth/data/user_repository/entities/my_user_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class CommentEntity {
  String commentId;
  DateTime createdAt;
  MyUser myUser; // Use MyUser instead of userId
  String? commentText;
  List<String> likes;

  CommentEntity({
    required this.commentId,
    required this.createdAt,
    required this.myUser, // Change from userId to MyUser
    this.commentText,
    this.likes = const [],
  });

  Map<String, Object?> toDocument() {
    return {
      'commentId': commentId,
      'commentText': commentText,
      'createdAt': createdAt,
      'myUser': myUser.toEntity().toDocument(), // Save MyUser as a reference
      'likes': likes,
    };
  }

  static CommentEntity fromDocument(Map<String, dynamic> doc) {
    return CommentEntity(
      commentId: doc['commentId'] as String,
      commentText: doc['commentText'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['myUser'])),
      likes: List<String>.from(doc['likes'] ?? []),
    );
  }

  List<Object?> get props =>
      [commentId, commentText, createdAt, myUser, likes];
}
