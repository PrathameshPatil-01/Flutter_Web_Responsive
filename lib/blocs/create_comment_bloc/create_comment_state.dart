part of 'create_comment_bloc.dart';

sealed class CreateCommentState extends Equatable {
  const CreateCommentState();

  @override
  List<Object> get props => [];
}

final class CreateCommentInitial extends CreateCommentState {}

final class CreateCommentFailure extends CreateCommentState {}

final class CreateCommentLoading extends CreateCommentState {}

final class CreateCommentSuccess extends CreateCommentState {
  final Post post;

  const CreateCommentSuccess(this.post);
}
