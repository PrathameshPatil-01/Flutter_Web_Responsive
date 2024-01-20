import 'package:web_auth/data/post_repository/entities/post_entity.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';

class Post {
  String postId;
  DateTime createdAt;
  MyUser myUser;
  String? content;
  String? imageUrl;
  List<dynamic> comments;
  List<String> likes;

  Post({
    required this.postId,
    required this.createdAt,
    required this.myUser,
    this.content,
    this.imageUrl,
    this.comments = const [],
    this.likes = const [],
  });

  // Empty user which represents an unauthenticated user.
  static final empty = Post(
    postId: '',
    content: '',
    createdAt: DateTime.now(),
    myUser: MyUser.empty,
    imageUrl: '',
    comments: [],
    likes: [],
  );

  // Modify MyUser parameters
  Post copyWith({
    String? postId,
    DateTime? createdAt,
    MyUser? myUser,
    String? content,
    String? imageUrl,
    List<dynamic>? comments,
    List<String>? likes,
  }) {
    return Post(
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      myUser: myUser ?? this.myUser,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
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
      createdAt: createdAt,
      myUser: myUser,
      imageUrl: imageUrl,
      likes: likes,
      comments: comments,
    );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      postId: entity.postId,
      content: entity.content,
      createdAt: entity.createdAt,
      myUser: entity.myUser,
      imageUrl: entity.imageUrl,
      likes: entity.likes,
      comments: entity.comments,
    );
  }

  @override
  String toString() {
    return 'Post(postId: $postId, createdAt: $createdAt, myUser: $myUser, content: $content, imageUrl: $imageUrl, comments: $comments, likes: $likes)';
  }
}
