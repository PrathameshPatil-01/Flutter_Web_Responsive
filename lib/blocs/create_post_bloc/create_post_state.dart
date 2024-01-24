part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

final class CreatePostInitial extends CreatePostState {}

final class CreatePostFailure extends CreatePostState {}

final class CreatePostLoading extends CreatePostState {}

final class CreatePostSuccess extends CreatePostState {
  final Post post;

  const CreatePostSuccess(this.post);
}

final class DeletePostInitial extends CreatePostState {}

final class DeletePostFailure extends CreatePostState {}

final class DeletePostLoading extends CreatePostState {}

final class DeletePostSuccess extends CreatePostState {}
