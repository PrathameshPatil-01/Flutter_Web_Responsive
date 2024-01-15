part of 'post_image_bloc.dart';

sealed class PostImageEvent extends Equatable {
  const PostImageEvent();

  @override
  List<Object> get props => [];
}

class UploadPostImage extends PostImageEvent {
  final html.File file;
  final String postId;
  final String userId;

  const UploadPostImage(this.file, this.postId, this.userId);

  @override
  List<Object> get props => [file, postId];
}
