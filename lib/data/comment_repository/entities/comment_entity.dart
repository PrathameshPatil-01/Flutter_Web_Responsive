import 'package:cloud_firestore/cloud_firestore.dart';

class CommentEntity {
  String commentId;
  DateTime createdAt;
  String? userId;
  String? commentText;
  List<String> likes;

  CommentEntity({
    required this.commentId,
    required this.createdAt,
    required this.userId,
    this.commentText,
    this.likes = const [],
  });

  Map<String, Object?> toDocument() {
    return {
      'commentId': commentId,
      'commentText': commentText,
      'createdAt': createdAt,
      'userId': userId,
      'likes': likes,
    };
  }

  static CommentEntity fromDocument(Map<String, dynamic> doc) {
    return CommentEntity(
      commentId: doc['commentId'] as String,
      commentText: doc['commentText'] as String,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      userId: doc['userId'] as String,
      likes: List<String>.from(doc['likes'] ?? []),
    );
  }

  List<Object?> get props =>
      [commentId, commentText, createdAt, userId, likes];
}
