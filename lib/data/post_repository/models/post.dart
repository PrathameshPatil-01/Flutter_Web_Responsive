import 'package:web_auth/data/post_repository/entities/post_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class Post {
  String postId;
  DateTime createAt;
  MyUser myUser;
  String? content;
  String? imageUrl;
  int commentsCount;
  int likesCount;

  Post({
    required this.postId,
    required this.createAt,
    required this.myUser,
    this.content,
    this.imageUrl,
    this.commentsCount = 0,
    this.likesCount = 0,
  });

  // Empty user which represents an unauthenticated user.
  static final empty = Post(
      postId: '',
      content: '',
      createAt: DateTime.now(),
      myUser: MyUser.empty,
      imageUrl: '',
      commentsCount: 0,
      likesCount: 0);

  // Modify MyUser parameters
  Post copyWith({
    String? postId,
    DateTime? createAt,
    MyUser? myUser,
    String? content,
    String? imageUrl,
    int? commentsCount,
    int? likesCount,
  }) {
    return Post(
      postId: postId ?? this.postId,
      createAt: createAt ?? this.createAt,
      myUser: myUser ?? this.myUser,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  // Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == Post.empty;

  // Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() {
    return PostEntity(
      postId: postId,
      content: content,
      createAt: createAt,
      myUser: myUser,
      imageUrl: imageUrl,
      likesCount: likesCount,
      commentsCount: commentsCount,
    );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      postId: entity.postId,
      content: entity.content,
      createAt: entity.createAt,
      myUser: entity.myUser,
      imageUrl: entity.imageUrl,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
    );
  }

  @override
  String toString() {
    return 'Post(postId: $postId, createAt: $createAt, myUser: $myUser, content: $content, imageUrl: $imageUrl, commentsCount: $commentsCount, likesCount: $likesCount)';
  }
}
