import 'package:web_auth/data/comment_repository/entities/comment_entity.dart';

class Comment {
  String commentId;
  DateTime createdAt;
  String? userId;
  String? commentText;
  List<String> likes;

  Comment({
    required this.commentId,
    required this.createdAt,
    required this.userId,
    this.commentText,
    this.likes = const [],
  });

  // Empty user which represents an unauthenticated user.
  static final empty = Comment(
    commentId: '',
    commentText: '',
    createdAt: DateTime.now(),
    userId: "",
    likes: [],
  );

  // Modify String parameters
  Comment copyWith({
    String? commentId,
    DateTime? createdAt,
    String? userId,
    String? commentText,
    List<String>? likes,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      commentText: commentText ?? this.commentText,
      likes: likes ?? this.likes,
    );
  }

  // Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == Comment.empty;

  // Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != Comment.empty;

  CommentEntity toEntity() {
    return CommentEntity(
      commentId: commentId,
      commentText: commentText,
      createdAt: createdAt,
      userId: userId,
      likes: likes,
    );
  }

  static Comment fromEntity(CommentEntity entity) {
    return Comment(
      commentId: entity.commentId,
      commentText: entity.commentText,
      createdAt: entity.createdAt,
      userId: entity.userId,
      likes: entity.likes,
    );
  }

  @override
  String toString() {
    return 'Comment(commentId: $commentId, createdAt: $createdAt, userId: $userId, commentText: $commentText, likes: $likes)';
  }
}
