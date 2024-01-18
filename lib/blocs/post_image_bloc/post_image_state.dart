part of 'post_image_bloc.dart';

sealed class PostImageState extends Equatable {
  const PostImageState();

  @override
  List<Object> get props => [];
}
class UploadPostImageInitial extends PostImageState {}

final class UploadPostImageLoading extends PostImageState {}

class UploadPostImageFailure extends PostImageState {}

class UploadPostImageSuccess extends PostImageState {
  final String postImage;

  const UploadPostImageSuccess(this.postImage);

  @override
  List<Object> get props => [postImage];
}
