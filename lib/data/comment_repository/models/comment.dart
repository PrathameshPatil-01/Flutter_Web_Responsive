import 'package:web_auth/data/comment_repository/entities/comment_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class Comment {
  String commentId;
  DateTime createdAt;
  MyUser myUser;
  String? commentText;
  List<String> likes;

  Comment({
    required this.commentId,
    required this.createdAt,
    required this.myUser,
    this.commentText,
    this.likes = const [],
  });

  // Empty user which represents an unauthenticated user.
  static final empty = Comment(
    commentId: '',
    commentText: '',
    createdAt: DateTime.now(),
    myUser: MyUser.empty,
    likes: [],
  );

  // Modify MyUser parameters
  Comment copyWith({
    String? commentId,
    DateTime? createdAt,
    MyUser? myUser,
    String? commentText,
    List<String>? likes,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      createdAt: createdAt ?? this.createdAt,
      myUser: myUser ?? this.myUser,
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
      myUser: myUser,
      likes: likes,
    );
  }

  static Comment fromEntity(CommentEntity entity) {
    return Comment(
      commentId: entity.commentId,
      commentText: entity.commentText,
      createdAt: entity.createdAt,
      myUser: entity.myUser,
      likes: entity.likes,
    );
  }

  @override
  String toString() {
    return 'Comment(commentId: $commentId, createdAt: $createdAt, myUser: $myUser, commentText: $commentText, likes: $likes)';
  }
}
